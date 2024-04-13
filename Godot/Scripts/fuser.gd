extends StaticBody2D

class_name Fuser

var child = null # this will hold the child in the fuser

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_card(card: Card) -> bool:
	if child == null:
		child = card
		card.position = self.position
		card.original_position = self.position
		return true
	return false


func remove_card(card: Card):
	# Should only ever have one
	child = null
	
