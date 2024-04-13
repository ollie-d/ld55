extends StaticBody2D

class_name Fuser

var child = null # this will hold the child in the fuser

signal create_card_in_fuser

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
	else:
		if card.card_type in global.interact_table[child.card_type].keys():
			print('reactable')
			# If mixable, return true AND queue the mix
			react(child, card)
			return true
	return false


func react(reactant0: Card, reactant1: Card):
	# If reaction is valid, delete old cards and create a new one
	var r0 = reactant0.card_type
	var r1 = reactant1.card_type
	
	if r1 in global.interact_table[r0].keys():
		var card_name = global.interact_table[r0][r1]
		remove_card(reactant0)
		reactant0.destroy()
		reactant1.destroy()
		
		# It'll be added afterwards don't worry
		child = null
		
		emit_signal("create_card_in_fuser", self, card_name)
	
	else:
		print("SOMETHING HAS GONE TERRIBLY WRONG")
	


func remove_card(card: Card):
	# Should only ever have one
	child = null
	
