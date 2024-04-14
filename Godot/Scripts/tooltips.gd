extends Node2D

var imp = """
turn start:
If possible, Create [wave amp=10 freq=5][color=red]1 fire[/color][/wave] in [color=purple]fuser[/color] to the right of card"""

var ent = """
turn start:
If possible, Create [wave amp=10 freq=5][color=red]1 wood[/color][/wave] in [color=purple]fuser[/color] left of the card"""

var boiling_water = """
If there are        [wave amp=10 freq=5][color=red]3 imps[/color][/wave] in play, [shake]boil[/shake] them and summon [wave amp=10 freq=5][color=red]1 demon[/color][/wave]"""

var newt = """
If card is created where [wave amp=10 freq=5][color=red]newt[/color][/wave] is, send created card to [color=blue]hand[/color]"""

var demon = """
Adds [wave amp=10 freq=5][color=red]1 water[/color][/wave], 
[wave amp=10 freq=5][color=red]1 fire[/color][/wave] and [wave amp=10 freq=5][color=red]1 wood[/color][/wave] to hand"""

var squid = """

Adds [wave amp=10 freq=5][color=red]water[/color][/wave] to all open [color=purple]fusers[/color]"""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
