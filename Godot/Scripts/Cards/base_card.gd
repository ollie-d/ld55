class_name Card extends Node2D

var card_type = 'base'
var art = null
var card_name: String


var card_types = {
	'fire': {'card_type': 'fire', 'art': 'res://Assets/Cards/Symbols/fire.png', 'card_name': '[center]Fire[/center]', 'mana_cost': 1, 'tooltip': null},
	'water': {'card_type': 'water', 'art': 'res://Assets/Cards/Symbols/water.png', 'card_name': '[center]Water[/center]', 'mana_cost': 1, 'tooltip': null},
	'boiling_water': {'card_type': 'boiling_water', 'art': 'res://Assets/Cards/Symbols/boiling_water.png', 'card_name': '[p][center]Boiling[/center][/p][p][center]Water[/center][/p]', 'mana_cost': 1, 'tooltip':null},
	'wood': {'card_type': 'wood', 'art': 'res://Assets/Cards/Symbols/wood.png', 'card_name': '[center]Wood[/center]', 'mana_cost': 1, 'tooltip':null},
	'ash': {'card_type': 'ash', 'art': 'res://Assets/Cards/Symbols/ash.png', 'card_name': '[center]Ash[/center]', 'mana_cost': 1, 'tooltip':null},
	'ent': {'card_type': 'ent', 'art': 'res://Assets/Cards/Symbols/ent.png', 'card_name': '[center]Ent[/center]', 'mana_cost': 1, 'tooltip':null},
	'imp': {'card_type': 'imp', 'art': 'res://Assets/Cards/Symbols/imp.png', 'card_name': '[center]Imp[/center]', 'mana_cost': 1, 'tooltip':tooltips.imp},
	'newt': {'card_type': 'newt', 'art': 'res://Assets/Cards/Symbols/newt.png', 'card_name': '[center]Newt[/center]', 'mana_cost': 1, 'tooltip':null},
	'eye_of_newt': {'card_type': 'eye_of_newt', 'art': 'res://Assets/Cards/Symbols/eye_of_newt.png', 'card_name': '[p][center]Eye of[/center][/p][p][center]Newt[/center][/p]', 'mana_cost': 1, 'tooltip':null},
}

var hovered = false
var is_in_fuser = false
var is_in_hand = false
var is_over_hand = false
var being_dragged = false
var is_over_fuser = false
var mana_cost = 1
var fuser_ref: Fuser
var hand_ref: Hand
var position_modifier = Vector2(0.0, -0.0)
var scale_modifier = Vector2(1.2, 1.2)

var original_position 

var being_destroyed = false

var tooltip = null

signal card_placed_in_fuser
signal card_placed_in_hand

# Called when the node enters the scene tree for the first time.
func _ready():
	if global.DEBUG:
		$ColorRect.visible = true
	else:
		$ColorRect.visible = false


func update_card():
	if art != null:
		%card_symbol.texture = load(art)
	%card_name.text = card_name
	if tooltip != null:
		%tooltip_desc.text = tooltip


func set_card(card_type_: String):
	assert(card_type_ in card_types.keys())
	
	card_type = card_types[card_type_]['card_type']
	art = card_types[card_type_]['art']
	card_name = card_types[card_type_]['card_name']
	mana_cost = card_types[card_type_]['mana_cost']
	tooltip = card_types[card_type_]['tooltip']
	
	update_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !being_destroyed:
		if hovered and not being_dragged:
			$ColorRect.color = Color(1.0, 1.0, 0.0)
		elif is_over_fuser:
			$ColorRect.color = Color(1.0, 0.0, 1.0)
		elif being_dragged and is_over_hand:
			$ColorRect.color = Color(0.0, 1.0, 1.0)
		elif being_dragged:
			$ColorRect.color = Color(0.0, 1.0, 0.0)
		else:
			$ColorRect.color = Color(1.0, 0.0, 0.0)
			
		if being_dragged:
			self.position = get_viewport().get_mouse_position()
		
		
		if being_dragged and is_over_hand and !is_in_hand:
			$x.visible = true
		else:
			$x.visible = false


func _physics_process(delta):
	# Make sure card is never being hovered and dragged
	if !being_destroyed:
		if being_dragged:
			hovered = false
		
		# Handle being placed over fuser or hand
		var bodies = $Area2D.get_overlapping_bodies()
		for body in bodies:
			if body is Fuser:
				is_over_fuser = true
				fuser_ref = body
			elif body is Hand:
				is_over_hand = true
				hand_ref = body
		
		# Handle mouse being hovered over
		if not being_dragged:
			var hover_check_failed = true
			if len(global.hover_queue) > 0:
				if self == global.hover_queue[0]:
					self.position += position_modifier
					self.scale = scale_modifier
					if tooltip != null:
						$tooltip.visible = true
					hover_check_failed = false
			if hover_check_failed and !hovered:
				self.position = original_position
				self.scale = Vector2(1.0, 1.0)
				$tooltip.visible = false
		else:
			$tooltip.visible = false


func destroy():
	being_destroyed = true
	self.position = Vector2(-100, -100)
	self.visible = false
	self.queue_free()


func _on_area_2d_mouse_entered():
	if (not global.card_being_held) and (not hovered) and (not being_dragged):
		global.add_card_to_hover_queue(self)
		hovered = true


func _on_area_2d_mouse_exited():
	global.remove_card_from_hover_queue(self)
	hovered = false



func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		# Detect start of drag
		if (event.button_index == 1) and (event.pressed == true) and (hovered) and (not being_dragged):
			being_dragged = true
			global.card_being_held = true
		# Detect end of drag
		elif (event.button_index == 1) and (event.pressed == false) and (being_dragged):
			# Add logic to check if it's in a fuser OR being re-arranged in hand
			being_dragged = false
			global.card_being_held = false
			
			if is_over_fuser:
				emit_signal("card_placed_in_fuser", fuser_ref, self)
			elif is_over_hand and is_in_hand:
				# Do not allow transfer to hand unless already in hand
				# TODO: make sure this doesn't allow you to steal hehe
				emit_signal("card_placed_in_hand", hand_ref, self)
			else:
				print('return to original place')
				self.position = original_position + position_modifier
			

func in_fuser():
	is_in_fuser = true
	is_in_hand = false


func in_hand():
	is_in_fuser = false
	is_in_hand = true


func _on_area_2d_area_entered(area):
	# Will be triggered when passes over other cards
	pass


func _on_area_2d_body_entered(body):
	# NOT BEING USED
	if body is Fuser:
		is_over_fuser = true
		fuser_ref = body
	elif body is Hand:
		is_over_hand = true
		hand_ref = body


func _on_area_2d_body_exited(body):
	if body is Fuser:
		is_over_fuser = false
	elif body is Hand:
		is_over_hand = false
