extends Node2D

var imp = """
If possible, Summon [wave amp=10 freq=5][color=#27362A]1 fire[/color][/wave] in [color=purple]fuser[/color] to the right of card"""

var ent = """
If possible, Summon [wave amp=10 freq=5][color=#27362A]1 wood[/color][/wave] in [color=purple]fuser[/color] left of the card"""

var boiling_water = """
If there are [wave amp=10 freq=5][color=#880015]3 imps[/color][/wave] in play, [shake]boil[/shake] them and summon [wave amp=10 freq=5][color=red]1 demon[/color][/wave]"""

var newt = """
If card is summoned where [wave amp=10 freq=5][color=#880015]newt[/color][/wave] is, send card to [color=blue]hand[/color]"""

var demon = """

Adds [wave amp=10 freq=5][color=#27362A]1 water[/color][/wave], 
[wave amp=10 freq=5][color=#27362A]1 fire[/color][/wave], and [wave amp=10 freq=5][color=#27362A]1 wood[/color][/wave] to hand"""

var squid = """

Adds [wave amp=10 freq=5][color=#27362A]water[/color][/wave] to all open [color=purple]fusers[/color]"""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
