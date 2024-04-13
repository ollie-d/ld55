extends Node2D

var DEBUG = false

var card_being_held = false
var card_being_hovered: Card = null

var hover_queue = []

var mana_max = 4
var mana = 4

var interact_table = {
	'fire': {'water': 'boiling_water', 'wood': 'ash', 'ash': 'imp', 'bone': 'charred_bone', 'eye_of_newt': 'ash'},
	'water': {'eye_of_newt': 'newt', 'wood': 'ent'},
	'wood': {'fire': 'ash', 'water': 'ent'},
	'ash': {'fire': 'imp', 'water': 'paste'}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_card_to_hover_queue(card: Card):
	hover_queue.append(card)

func remove_card_from_hover_queue(card: Card):
	if hover_queue.has(card):
		hover_queue.pop_at(hover_queue.find(card))
