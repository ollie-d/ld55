extends Fuser

#var is_deposit = true
var deposits_needed = 9
var deposits_left = 9
var tornado_r = 4.0

var deposit_type = 'fire'

signal level_complete
signal valid_deposit

func _init():
	is_deposit = true # godot pls let me ignore errors when you're wrong :(


func _ready():
	update_text()

func show_tutorial():
	%hand_hint.visible = true
	%hint_text.visible = true


func hide_tutorial():
	%hand_hint.visible = false
	%hint_text.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_text():
	if deposits_left > 0:
		%deposit_label.text = """
[tornado radius={r} freq={f}][center]x{dl}[/center][/tornado]""".format({'dl':deposits_left, 'r':tornado_r, 'f':10-deposits_left})
	else:
		%deposit_label.text = """
[center]x0[/center]"""


func update_card_label():
	$card_type.text = global.card_types[deposit_type]['card_name']
	%glyph.texture = load(global.card_types[deposit_type]['art'])


func play_deposit_sound():
	var r = RandomNumberGenerator.new()
	r.randomize()
	%deposit_sound.pitch_scale = r.randf_range(0.9, 1.0)
	%deposit_sound.play()


func check_deposit(card: Card):
	# If deposit valid, update text
	if card.card_type == deposit_type:
		print("got a valid deposit")
		play_deposit_sound()
		deposits_left -= 1
		print('emitting valid deposit')
		emit_signal("valid_deposit")
		update_text()
		
		# Remove card from hand/fuser
		card.home_object.remove_card(card)
		card.destroy()
		
		if deposits_left <= 0:
			emit_signal("level_complete")
		
		return true
	else:
		print('Invalid deposit')
	return false
