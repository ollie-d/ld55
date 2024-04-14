class_name Fuser extends StaticBody2D

var child: Card = null # this will hold the child in the fuser

var is_deposit = false

signal create_card_in_fuser

# Called when the node enters the scene tree for the first time.
func _ready():
	if global.DEBUG:
		$Label.visible = true
	else:
		$Label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if child != null:
		$Label.text = str(child.card_type)
	else:
		$Label.text = 'null'


func add_card(card: Card) -> bool:
	if child == card:
		#print('Child IS card')
		card.position = self.position
		card.original_position = self.position
	elif child == null:
		#print('Child is null')
		if !global.turn_ended:
			play_placed_sound()
		child = card
		card.position = self.position
		card.original_position = self.position
		if card.home_object != null:
			# If not a fresh card, tell its old owner to drop it
			card.home_object.remove_card(card)
		if !is_deposit:
			card.set_home(self)
		return true
	else:
		#print('Reaction check')
		# Check either combination of cards
		var card0: Card
		var card1: Card
		
		for i in range(2):
			card0 = card
			card1 = child
			if i == 0:
				card0 = child
				card1 = card
				
			if card0.card_type in global.interact_table.keys():
				if card1.card_type in global.interact_table[card0.card_type].keys():
					#print('reactable')
					# If mixable, return true AND queue the mix
					react(card0, card1)
					return true
			print('not reactable')
	return false


func play_placed_sound():
	var r = RandomNumberGenerator.new()
	r.randomize()
	%placed_sound.pitch_scale = r.randf_range(0.8, 1.0)
	%placed_sound.play()


func play_activated_sound():
	var r = RandomNumberGenerator.new()
	r.randomize()
	%activated_sound.pitch_scale = r.randf_range(0.8, 1.0)
	%activated_sound.play()


func react(reactant0: Card, reactant1: Card):
	# If reaction is valid, delete old cards and create a new one
	var r0 = reactant0.card_type
	var r1 = reactant1.card_type
	
	if r1 in global.interact_table[r0].keys():
		var card_name = global.interact_table[r0][r1]
		if reactant1.home_object != null:
			reactant1.home_object.remove_card(reactant1)
		if reactant0.home_object != null:
			reactant0.home_object.remove_card(reactant0)
		reactant0.destroy()
		reactant1.destroy()
		
		# It'll be added afterwards don't worry
		child = null
		
		emit_signal("create_card_in_fuser", self, card_name)
	
	else:
		print("SOMETHING HAS GONE TERRIBLY WRONG")
	


func remove_card(card: Card):
	# Should only ever have one
	print('Remove card called')
	child = null
	


func kill_child():
	if child != null:
		child.destroy()
	child = null
