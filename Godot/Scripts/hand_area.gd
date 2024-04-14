extends StaticBody2D

class_name Hand

# Store all cards contained within hand
var cards = []
#var card_positions = []
var card_w = 91
var max_cards = 7
var overlap_len = 7
var card_y = 73
var min_x = 57
var max_x = 701
var card_spacing = 5
var default_card_spacing = 5
var origin: Vector2#Vector2(379.0, 72.0)


# Called when the node enters the scene tree for the first time.
func _ready():
	origin = $CollisionShape2D.get_global_position()
	if global.DEBUG:
		$cards.visible = true
		$pos.visible = true
	else:
		$cards.visible = false
		$pos.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.DEBUG:
		$cards.text = str(cards)
		#$pos.text = str(card_positions)


func add_card(card):
	if len(cards) < max_cards:
		if card not in cards:
			cards.append(card)
			arrange_cards()
			card.set_home(self)
			card.z_index = card.default_z
			return true
	else:
		print('Hand full')
		card.destroy()
	return false


func remove_card(card):
	if cards.has(card):
		var card_ix = cards.find(card)
		#card_positions.pop_at(card_ix)
		cards.pop_at(card_ix)
	arrange_cards()


func clear_hand():
	for card in cards:
		card.destroy()
	cards = []
	arrange_cards()

func arrange_cards():
	# make sure the cards are arranged in a neat and readable fashion
	if len(cards) > overlap_len:
		# Limit cards, so don't allow this
		pass
	else:
		var i = 0
		var box_size = (card_w+card_spacing) * len(cards)
		for card in cards:
			card.position = origin + Vector2(((card_w+card_spacing)*i) - (box_size/2) + (card_w/2), 0)
			card.original_position = card.position
			i += 1
	
	# Update text
	%card_count.text = "{count}/{max}".format({'count':len(cards), 'max':max_cards})
	
