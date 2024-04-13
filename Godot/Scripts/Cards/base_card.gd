extends Node2D

class_name Card

@export var card_type = 'base'

var hovered = false
var is_in_fuser = false
var is_in_hand = false
var is_over_hand = false
var being_dragged = false
var is_over_fuser = false
var fuser_ref: Fuser
var hand_ref: Hand
var position_modifier = Vector2(0.0, -0.0)
var scale_modifier = Vector2(1.2, 1.2)

var ignore_

var original_position 

signal card_placed_in_fuser
signal card_placed_in_hand

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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


func _physics_process(delta):
	# Make sure card is never being hovered and dragged
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
				hover_check_failed = false
		if hover_check_failed:
			self.position = original_position
			self.scale = Vector2(1.0, 1.0)


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
			elif is_over_hand:
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
