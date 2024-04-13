extends Fuser

#var is_deposit = true
var deposits_left = 9
var tornado_r = 4.0

var deposit_type = 'fire'

func _init():
	is_deposit = true # godot pls let me ignore errors when you're wrong :(


func _ready():
	update_text()


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


func check_deposit(card: Card):
	# If deposit valid, update text
	if card.card_type == deposit_type:
		print("got a valid deposit")
		deposits_left -= 1
		update_text()
		card.destroy()
		return true
	else:
		print('Invalid deposit')
	return false
