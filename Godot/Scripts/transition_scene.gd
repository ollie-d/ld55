extends CanvasLayer

signal transition_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	%ColorRect.visible = false
	%AnimationPlayer.animation_finished.connect(animation_finished)


func transition():
	%ColorRect.visible = true
	%AnimationPlayer.play("fade_to_black")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func animation_finished(animation):
	if animation == 'fade_to_black':
		%AnimationPlayer.play('fade_to_normal')
		emit_signal('transition_finished')
	elif animation == 'fade_to_normal':
		%ColorRect.visible = false
