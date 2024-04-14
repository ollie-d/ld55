extends Node2D

@onready var play_area = preload("res://Scenes/play_area.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_game():
	transition.transition()
	await transition.transition_finished
	get_tree().change_scene_to_packed(play_area)
	


func _on_play_pressed():
	%play_sound.play()
	start_game()
