class_name Card extends Node2D

var card_type = 'base'
var art = null
var card_name: String


var hovered = false
var is_in_fuser = false
var is_in_hand = false
var is_over_hand = false
var being_dragged = false
var is_over_fuser = false
var is_over_mana = false
var mana_cost = 1
var fuser_ref: Fuser
var hand_ref: Hand
var position_modifier = Vector2(0.0, -0.0)
var scale_modifier = Vector2(1.2, 1.2)

var default_z = 1.0
var original_position 

var being_destroyed = false

var home_object

var tooltip = null

signal card_placed_in_fuser
signal card_placed_in_hand
signal mana_added

# Called when the node enters the scene tree for the first time.
func _ready():
	if global.DEBUG:
		$ColorRect.visible = true
		$z.visible = true
	else:
		$ColorRect.visible = false
		$z.visible = false
	
	self.z_index = default_z


func set_home(object):
	home_object = object

func update_card():
	if art != null:
		%card_symbol.texture = load(art)
	%card_name.text = card_name
	if tooltip != null:
		%tooltip_desc.text = tooltip
	%cost.text = str(mana_cost)


func set_card(card_type_: String):
	assert(card_type_ in global.card_types.keys())
	
	card_type = global.card_types[card_type_]['card_type']
	art = global.card_types[card_type_]['art']
	card_name = global.card_types[card_type_]['card_name']
	mana_cost = global.card_types[card_type_]['mana_cost']
	tooltip = global.card_types[card_type_]['tooltip']
	
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
		elif being_dragged and is_over_mana and !is_in_hand:
			$x.visible = true
		elif being_dragged and is_over_fuser and fuser_ref.is_deposit and fuser_ref.deposit_type != self.card_type:
			$x.visible = true
		else:
			$x.visible = false
		
		$z.text = str(self.z_index)


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
			elif body is Mana:
				is_over_mana = true
		
		# Handle mouse being hovered over
		if (not being_dragged) and (home_object != null):
			var hover_check_failed = true
			if len(global.hover_queue) > 0:
				if self == global.hover_queue[0]:
					self.position = original_position + position_modifier
					self.scale = scale_modifier
					if tooltip != null:
						$tooltip.visible = true
					self.z_index = 10
					%card.material.set_shader_parameter("width", 2)
					hover_check_failed = false
			if hover_check_failed and !hovered:
				self.position = original_position
				self.scale = Vector2(1.0, 1.0)
				%card.material.set_shader_parameter("width", 0)
				self.z_index = default_z
				$tooltip.visible = false
		else:
			$tooltip.visible = false
			self.z_index = 10
			%card.material.set_shader_parameter("width", 0)


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
	if (event is InputEventMouseButton) and (!global.turn_ended):
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
				emit_signal("card_placed_in_hand", hand_ref, self)
			elif is_over_mana and is_in_hand:
				# Give player mana worth the card and destroy it
				global.mana += self.mana_cost
				emit_signal("mana_added")
				self.home_object.remove_card(self)
				self.destroy()
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


func _on_area_2d_body_exited(body):
	if body is Fuser:
		is_over_fuser = false
	elif body is Hand:
		is_over_hand = false
	elif body is Mana:
		is_over_mana = false
