@tool
extends Node2D

@export var product = ''
@export var reactants = ''
var default_color = "#3D281D"
var hover_color = "#ffffff"

# Called when the node enters the scene tree for the first time.
func _ready():
	%reactants.visible = false
	%product.text = "[color={c}]{t}[/color]".format({'c':default_color, 't':product})
	%reactants.text = reactants


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		%product.text = "[color={c}]{t}[/color]".format({'c':default_color, 't':product})
		%reactants.text = reactants
		%reactants.visible = true

func hover(state: bool):
	if state:
		%product.text = "[color={c}]{t}[/color]".format({'c':hover_color, 't':product})
		%reactants.visible = true
	else:
		%product.text = "[color={c}]{t}[/color]".format({'c':default_color, 't':product})
		%reactants.visible = false


func _on_area_2d_mouse_entered():
	hover(true)


func _on_area_2d_mouse_exited():
	hover(false)
