extends Node2D

var DEBUG = true

var card_being_held = false
var card_being_hovered: Card = null

var turn_ended = false

var hover_queue = []

var mana_max = 4
var mana = 4

var interact_table = {
	'fire': {'water': 'boiling_water', 'wood': 'ash', 'ash': 'imp', 'eye_of_newt': 'ash'},
	'water': {'eye_of_newt': 'newt', 'wood': 'ent'},
	'wood': {'fire': 'ash', 'water': 'ent'},
	'ash': {'fire': 'imp', 'water': 'paste'},
	'ent': {'fire': 'ash'},
	'imp': {'paste': 'newt'},
	'newt': {'wood': 'eye_of_newt'}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	if DEBUG:
		$hover_queue.visible = true
	else:
		$hover_queue.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if DEBUG:
		$hover_queue.text = str(hover_queue)

func _physics_process(delta):
	# periodically check for freed memory in hover_queue
	var i = 0
	for item in hover_queue:
		if !is_instance_valid(item):
			hover_queue.pop_at(i)
			print('Freed item removed from hover queue')
		i += 1


func add_card_to_hover_queue(card: Card):
	hover_queue.append(card)

func remove_card_from_hover_queue(card: Card):
	if hover_queue.has(card):
		hover_queue.pop_at(hover_queue.find(card))
