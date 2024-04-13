extends StaticBody2D

class_name Hand

# Store all cards contained within hand
var cards = []
var card_positions = []
var card_w = 91
var overlap_len = 8
var card_y = 73
var min_x = 57
var max_x = 701
var card_spacing = 5
var origin: Vector2#Vector2(379.0, 72.0)


# Called when the node enters the scene tree for the first time.
func _ready():
	origin = $CollisionShape2D.get_global_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_card(card):
	# add card to hand area
	if card not in cards:
		cards.append(card)
		arrange_cards()


func remove_card(card):
	if cards.has(card):
		var card_ix = cards.find(card)
		card_positions.pop_at(card_ix)
		cards.pop_at(card_ix)
	arrange_cards()


func arrange_cards():
	# make sure the cards are arranged in a neat and readable fashion
	if len(cards) > overlap_len:
		# deal with overlap spacing
		pass
	else:
		var i = 0
		var box_size = (card_w+card_spacing) * len(cards)
		for card in cards:
			card.position = origin + Vector2(((card_w+card_spacing)*i) - (box_size/2) + (card_w/2), 0)
			card.original_position = card.position
			i += 1
	
