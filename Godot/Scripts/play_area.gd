extends Node2D

# keep track of all valid fusers in play area
var fusers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Fuser.create_card_in_fuser.connect(create_card_in_fuser)
	$Fuser2.create_card_in_fuser.connect(create_card_in_fuser)
	$Fuser3.create_card_in_fuser.connect(create_card_in_fuser)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func create_card_in_fuser(fuser: Fuser, card_type: String):
	create_card(card_type, null, fuser)


func create_card(card_type: String, hand: Hand = null, fuser: Fuser = null):
	# have card_type be an enum that refers to the correct card path. global
	var card_scene = load("res://Scenes/Cards/base_card.tscn")
	var card = card_scene.instantiate()
	self.add_child(card)
	card.set_card(card_type)
	card.card_placed_in_fuser.connect(card_placed_in_fuser)
	card.card_placed_in_hand.connect(card_placed_in_hand)
	
	assert(not((fuser != null) and (hand != null)))
	
	if fuser == null and hand == null:
		# By default, add card into player's hand
		# TODO: THIS NEEDS TO BE REMOVED AT SOME PONT
		%hand.add_card(card)
		card.in_hand()
	elif fuser != null and hand == null:
		fuser.add_card(card)
		card.in_fuser()
		pass
	elif fuser == null and hand != null:
		hand.add_card(card)
		card.in_hand()
		


func _on_button_pressed():
	create_card('water')


func card_placed_in_hand(hand: Hand, card: Card):
	if card.is_in_hand:
		card.hand_ref.remove_card(card)
	elif card.is_in_fuser:
		card.fuser_ref.remove_card(card)
	card.in_hand()
	hand.add_card(card)


func card_placed_in_fuser(fuser: Fuser, card: Card):
	if card.is_in_hand:
		card.hand_ref.remove_card(card)
	elif card.is_in_fuser:
		card.fuser_ref.remove_card(card)
	
	# Make sure the card CAN be added to the fuser, if not return
	if fuser.add_card(card):
		print('Added to fuser')
		card.in_fuser()
	else:
		if card.is_in_hand:
			card.hand_ref.add_card(card)
		elif card.is_in_fuser:
			card.fuser_ref.add_card(card)
	


func _on_button_2_pressed():
	create_card('fire')


func _on_button_3_pressed():
	create_card('boiling_water')


func _on_button_4_pressed():
	create_card($TextEdit.text.to_lower())
