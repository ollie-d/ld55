extends Node2D

var DEBUG = false

var enable_mana = false

var card_being_held = false
var card_being_hovered: Card = null

var turn_ended = false

var hover_queue = []

# Have max turns?
var turns_taken = 0
var max_turns: int

var mana_max = 4
var mana = 4

var current_level = 0
var num_levels: int

var levels = {
	0: {'starting_resources':['fire','wood'], 'deposit':{'card_type':'ash', 'quantity':1}, 'max_turns': 1},
	1: {'starting_resources':[], 'deposit':{'card_type':'fire', 'quantity':3}, 'max_turns': 3},
	2: {'starting_resources':[], 'deposit':{'card_type':'ash', 'quantity':2}, 'max_turns': 2},
	3: {'starting_resources':['fire','wood','water'], 'deposit':{'card_type':'paste', 'quantity':1}, 'max_turns': 2},
	4: {'starting_resources':['eye_of_newt', 'fire', 'fire'], 'deposit':{'card_type':'imp', 'quantity':1}, 'max_turns': 3},
	5: {'starting_resources':['squid', 'fire', 'wood'], 'deposit':{'card_type':'ash', 'quantity':3}, 'max_turns': 5},
	6: {'starting_resources':['newt','water', 'fire', 'fire', 'wood'], 'deposit':{'card_type':'imp', 'quantity':5}, 'max_turns': 10},
	7: {'starting_resources':['fire', 'fire', 'wood', 'water', 'water', 'newt'], 'deposit':{'card_type':'demon', 'quantity':1}, 'max_turns': 10},
}

var interact_table = {
	'fire': {'water': 'boiling_water', 'wood': 'ash', 'ash': 'imp', 'eye_of_newt': 'ash'},
	'water': {'eye_of_newt': 'newt', 'wood': 'ent'},
	'wood': {'fire': 'ash', 'water': 'ent'},
	'ash': {'fire': 'imp', 'water': 'paste'},
	'ent': {'fire': 'ash', 'water': 'squid'},
	'imp': {'paste': 'newt', 'water': 'squid'},
	'newt': {'wood': 'eye_of_newt', 'fire': 'eye_of_newt'},
	'squid': {'wood': 'ent', 'fire': 'imp'},
}

var card_types = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	card_types = {
	'fire': {'card_type': 'fire', 'art': 'res://Assets/Cards/Symbols/fire.png', 'card_name': '[center]Fire[/center]', 'mana_cost': 1, 'tooltip': null},
	'water': {'card_type': 'water', 'art': 'res://Assets/Cards/Symbols/water.png', 'card_name': '[center]Water[/center]', 'mana_cost': 1, 'tooltip': null},
	'boiling_water': {'card_type': 'boiling_water', 'art': 'res://Assets/Cards/Symbols/boiling_water.png', 'card_name': '[shake][p][center][color=#880015]Boiling[/color][/center][/p][p][center][color=#880015]Water[/color][/center][/p][/shake]', 'mana_cost': 1, 'tooltip':tooltips.boiling_water},
	'wood': {'card_type': 'wood', 'art': 'res://Assets/Cards/Symbols/wood.png', 'card_name': '[center]Wood[/center]', 'mana_cost': 1, 'tooltip':null},
	'ash': {'card_type': 'ash', 'art': 'res://Assets/Cards/Symbols/ash.png', 'card_name': '[center]Ash[/center]', 'mana_cost': 1, 'tooltip':null},
	'ent': {'card_type': 'ent', 'art': 'res://Assets/Cards/Symbols/ent.png', 'card_name': '[center][wave][color=#880015]Ent[/color][/wave][/center]', 'mana_cost': 1, 'tooltip':tooltips.ent},
	'imp': {'card_type': 'imp', 'art': 'res://Assets/Cards/Symbols/imp.png', 'card_name': '[center][wave][color=#880015]Imp[/color][/wave][/center]', 'mana_cost': 1, 'tooltip':tooltips.imp},
	'newt': {'card_type': 'newt', 'art': 'res://Assets/Cards/Symbols/newt.png', 'card_name': '[center][wave][color=#880015]Newt[/color][/wave][/center]', 'mana_cost': 1, 'tooltip':tooltips.newt},
	'eye_of_newt': {'card_type': 'eye_of_newt', 'art': 'res://Assets/Cards/Symbols/eye_of_newt.png', 'card_name': '[p][center]Eye of[/center][/p][p][center]Newt[/center][/p]', 'mana_cost': 1, 'tooltip':null},
	'paste': {'card_type': 'paste', 'art': 'res://Assets/Cards/Symbols/paste.png', 'card_name': '[center]Paste[/center]', 'mana_cost': 1, 'tooltip':null},
	'demon': {'card_type': 'demon', 'art': 'res://Assets/Cards/Symbols/demon.png', 'card_name': '[center][wave][color=#880015]Demon[/color][/wave][/center]', 'mana_cost': 2, 'tooltip':tooltips.demon},
	'squid': {'card_type': 'squid', 'art': 'res://Assets/Cards/Symbols/squid.png', 'card_name': '[center][wave][color=#880015]Squid[/color][/wave][/center]', 'mana_cost': 2, 'tooltip':tooltips.squid},
	}
	
	if DEBUG:
		levels[len(levels)-1]['deposit']['card_type'] = 'fire'
	
	if !enable_mana:
		for key in card_types.keys():
			card_types[key]['mana_cost'] = 0
	
	num_levels = len(levels.keys())
	$hover_queue.z_index = 99
	if DEBUG:
		$hover_queue.visible = true
	else:
		$hover_queue.visible = false
	
	$Music.play()


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
