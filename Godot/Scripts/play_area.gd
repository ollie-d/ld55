extends Node2D

# keep track of all valid fusers in play area
var fusers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#create_card('ligma')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func create_card(card_type: String):
	# have card_type be an enum that refers to the correct card path. global
	var card_scene = load("res://Scenes/Cards/base_card.tscn")
	var card = card_scene.instantiate()
	self.add_child(card)
	%hand.add_card(card)
	card.in_hand()
	card.card_placed_in_fuser.connect(card_placed_in_fuser)
	card.card_placed_in_hand.connect(card_placed_in_hand)


func _on_button_pressed():
	create_card('fu')


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
		card.in_fuser()
	else:
		if card.is_in_hand:
			card.hand_ref.add_card(card)
		elif card.is_in_fuser:
			card.fuser_ref.add_card(card)
	
