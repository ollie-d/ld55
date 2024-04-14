extends Node2D

# keep track of all valid fusers in play area
var fusers = []

signal card_created
signal hint_clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	fusers.append($Fuser)
	fusers.append($Fuser2)
	fusers.append($Fuser3)
	fusers.append($Fuser4)
	fusers.append($Fuser5)
	
	$Fuser.create_card_in_fuser.connect(create_card_in_fuser)
	$Fuser2.create_card_in_fuser.connect(create_card_in_fuser)
	$Fuser3.create_card_in_fuser.connect(create_card_in_fuser)
	$Fuser4.create_card_in_fuser.connect(create_card_in_fuser)
	$Fuser5.create_card_in_fuser.connect(create_card_in_fuser)
	
	%deposit.level_complete.connect(level_complete)
	
	if global.DEBUG:
		$Button.visible = true
		$Button2.visible = true
		$Button3.visible = true
		$Button4.visible = true
		$TextEdit.visible = true
		$Button5.visible = true
		$Button6.visible = true
		$Button7.visible = true
		$Button8.visible = true
		$Button9.visible = true
		$Button10.visible = true
	
	if global.enable_mana:
		%mana_label.visible = true
		%mana_title.visible = true
		%ManaZone.visible = true
		%ManaZone/CollisionShape2D.disabled = false
	else:
		%mana_label.visible = false
		%mana_title.visible = false
		%ManaZone.visible = false
		%ManaZone/CollisionShape2D.disabled = true
	
	# will move this later
	load_level()


func add_all_fusers():
	fusers = []
	fusers.append($Fuser)
	fusers.append($Fuser2)
	fusers.append($Fuser3)
	fusers.append($Fuser4)
	fusers.append($Fuser5)
	
	for fuser in fusers:
		fuser.visible = true


func clear_play_area():
	# Remove all cards from fusers and hand
	global.mana = global.mana_max
	update_mana()
	for fuser in fusers:
		fuser.kill_child()
	%hand.clear_hand()
	%deposit.deposits_left = %deposit.deposits_needed
	%deposit.update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func toggle_main_ui_visibility(state: bool):
	# Toggles the state of all of the important UI elements
	toggle_turns_visibility(state)
	%deposit.visible = state
	%end_turn.visible = state
	%restart.visible = state
	%hint_button.visible = state

func toggle_turns_visibility(state: bool):
	$turns_label.visible = state
	$turns_title.visible = state

func load_level():
	clear_play_area()
	for card_type in global.levels[global.current_level]['starting_resources']:
		create_card_in_hand(%hand, card_type)
	%deposit.deposit_type = global.levels[global.current_level]['deposit']['card_type']
	%deposit.deposits_needed = global.levels[global.current_level]['deposit']['quantity']
	%deposit.deposits_left = %deposit.deposits_needed
	%deposit.update_text()
	%deposit.update_card_label()
	
	%level.text = 'Level {x} / {y}'.format({'x':global.current_level+1, 'y':global.num_levels})
	
	global.turns_taken = 0
	global.max_turns = global.levels[global.current_level]['max_turns']
	update_turns()
	update_mana()
	
	# Hide all tutorial stuff by default
	%tut_text0.visible = false
	%tut_text1.visible = false
	%tut_text2.visible = false
	%tut_text3.visible = false
	%tut_text4.visible = false
	%tut_text5.visible = false
	%tut_text6.visible = false
	%tut_text7.visible = false
	%hint_arrow.visible = false
	%deposit.hide_tutorial()
	
	# Handle tutorial levels
	if global.current_level == 0:
		# Hide UI elements
		%tut_text0.visible = true
		toggle_main_ui_visibility(false)
		
		# Only keep center fuser
		for fuser in fusers:
			fuser.visible = false
		fusers = [$Fuser3]
		$Fuser3.visible = true
		
		await $Fuser3.create_card_in_fuser
		
		%tut_text0.visible = false
		%deposit.show_tutorial()
		%deposit.visible = true
		
		await %deposit.level_complete
		%deposit.hide_tutorial()
	
	elif global.current_level == 1:
		toggle_main_ui_visibility(false)
		%tut_text1.visible = true
		%deposit.visible = true
		for fuser in fusers:
			fuser.visible = false
		fusers = [$Fuser2, $Fuser3, $Fuser4]
		for fuser in fusers:
			fuser.visible = true
		create_card_in_fuser($Fuser3, 'imp')
		
		$Fuser3.child.locked_in_place = true
		
		await $Fuser3.child.card_hovered
		
		%tut_text1.visible = false
		%end_turn.visible = true
		%tut_text2.visible =true
		
		await self.card_created
		%tut_text2.visible = false
		%deposit.show_tutorial()
		
		await %deposit.valid_deposit
		
		%deposit.hide_tutorial()
		%tut_text3.visible = true
		
		toggle_turns_visibility(true)
		
		await %deposit.level_complete
		%tut_text3.visible = false
		
	elif global.current_level == 2:
		toggle_main_ui_visibility(true)
		%hint_button.visible = false
		%restart.visible = false
		for fuser in fusers:
			fuser.visible = false
		fusers = [$Fuser2, $Fuser3, $Fuser4]
		for fuser in fusers:
			fuser.visible = true
		
		create_card_in_fuser($Fuser2, 'imp')
		create_card_in_fuser($Fuser4, 'ent')
		
		$Fuser2.child.locked_in_place = true
		$Fuser4.child.locked_in_place = true
		
		%tut_text4.visible = true
	
	elif global.current_level == 3:
		toggle_main_ui_visibility(true)
		%hint_button.visible = false
		%hint_arrow.visible = false
		%tut_text4.visible = false
		%tut_text5.visible = true
		%restart.visible = true
		
		await self.card_created
		%tut_text5.visible = false
		
		%tut_text6.visible = true
		%hint_button.visible = true
		%hint_arrow.visible = true
		
		await self.hint_clicked
		
		%tut_text6.visible = false
		%hint_arrow.visible = false
		
		await self.hint_clicked
		
		%tut_text7.visible = true
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 2.0
		timer.one_shot = true
		timer.start()
		await timer.timeout
		%tut_text7.visible = false
		
		
		
		
	else:
		add_all_fusers()
		toggle_main_ui_visibility(true)


func reset_level():
	transition.transition()
	await transition.transition_finished
	load_level()


func imp_action(fuser: Fuser):
	if (fuser.child != null) and (fuser.child.card_type == 'newt'):
			create_card_in_hand(%hand, 'fire')
	else:
		create_card_in_fuser(fuser, 'fire')


func ent_action(fuser: Fuser):
	if (fuser.child != null) and (fuser.child.card_type == 'newt'):
			create_card_in_hand(%hand, 'wood')
	else:
		create_card_in_fuser(fuser, 'wood')


func boiling_water_action(active_fuser: Fuser):
	# Check if there are 3 imps  to boil >:)
	var imp_fusers = []
	
	for fuser in fusers:
		if fuser.child != null:
			if fuser.child.card_type == 'imp':
				print('fuser has an imp')
				imp_fusers.append(fuser)
		if len(imp_fusers) >= 3:
			break
	
	if len(imp_fusers) >= 3:
		# Should only ever be 3
		for fuser in imp_fusers:
			fuser.kill_child()
			# Replace active fuser with a Demon
		active_fuser.kill_child()
		create_card_in_fuser(active_fuser, 'demon')
	
	
func demon_action():
	create_card_in_hand(%hand, 'water')
	create_card_in_hand(%hand, 'fire')
	create_card_in_hand(%hand, 'wood')


func squid_action():
	var empty_fusers = []
	for fuser in fusers:
		if fuser.child == null:
			empty_fusers.append(fuser)
	for fuser in empty_fusers:
		create_card_in_fuser(fuser, 'water')


func perform_action(left_fuser: Fuser, active_fuser: Fuser, right_fuser: Fuser):
	# Perform the action of the card if it has one
	if (active_fuser.child.card_type == 'imp') and (right_fuser != null):
		imp_action(right_fuser)
	elif (active_fuser.child.card_type == 'ent') and (left_fuser != null):
		ent_action(left_fuser)
	elif active_fuser.child.card_type == 'boiling_water':
		boiling_water_action(active_fuser)
	elif active_fuser.child.card_type == 'demon':
		demon_action()
	elif active_fuser.child.card_type == 'squid':
		squid_action()


func game_over():
	transition.transition()
	await transition.transition_finished
	var credits = preload("res://Scenes/game_over.tscn")
	get_tree().change_scene_to_packed(credits)


func level_complete():
	# Logic for what to do after a level has been beaten
	global.current_level += 1
	if global.current_level >= global.num_levels:
		game_over()
	else:
		transition.transition()
		await transition.transition_finished
		load_level()

func end_turn():
	# Let's check through our fusers in order to see how to process
	%end_turn.disabled = true
	global.turn_ended = true
	%arrow.visible = true
	var i = 0
	for fuser in fusers:
		%arrow.position = fuser.position
		
		# If fuser is not empty, have child perform action
		if fuser.child != null:
			fuser.play_activated_sound()
			if i == 0 and len(fusers) >= 2:
				perform_action(null, fuser, fusers[i+1])
			elif (i == len(fusers)-1) and (len(fusers) >= 2):
				perform_action(fusers[i-1], fuser, null)
			else:
				if len(fusers) >= 3:
					perform_action(fusers[i-1], fuser, fusers[i+1])
		
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.3
		timer.one_shot = true
		timer.start()
		await timer.timeout
		i += 1
	%arrow.visible = false
	
	# Reset mana
	global.mana = max(global.mana, global.mana_max)
	update_mana()
	
	# Change turns
	global.turns_taken += 1
	if global.turns_taken > global.max_turns:
		# If you're out of turns reset
		reset_level()
	else:
		update_turns()
	
	global.turn_ended = false
	%end_turn.disabled = false


func update_mana():
	%mana_label.text = "{mana} / {max}".format({'mana':global.mana, 'max':global.mana_max})


func update_turns():
	%turns_label.text = "[center]{t}/{tmax}[/center]".format({'t':global.max_turns-global.turns_taken, 'tmax':global.max_turns})


func create_card_in_hand(hand: Hand, card_type: String):
	create_card(card_type, hand, null)


func create_card_in_fuser(fuser: Fuser, card_type: String):
	create_card(card_type, null, fuser)


func create_card(card_type: String, hand: Hand = null, fuser: Fuser = null):
	# have card_type be an enum that refers to the correct card path. global
	var card_scene = load("res://Scenes/Cards/base_card.tscn")
	var card = card_scene.instantiate()
	self.add_child(card)
	card.set_card(card_type)
	card.card_placed_in_fuser.connect(card_placed_in_fuser)
	card.card_placed_in_hand.connect(card_placed_in_hand)
	card.mana_added.connect(update_mana)
	card.z_index = card.default_z
	
	assert(not((fuser != null) and (hand != null)))
	
	if fuser == null and hand == null:
		# By default, add card into player's hand
		# TODO: THIS NEEDS TO BE REMOVED AT SOME PONT
		if %hand.add_card(card):
			card.in_hand()
		else:
			print('Card cannot be added, destroyed instead')
			card.destroy()
	elif fuser != null and hand == null:
		if fuser.add_card(card):
			emit_signal("card_created")
			card.in_fuser()
			card.home_object = fuser
		else:
			card.destroy()
		pass
	elif fuser == null and hand != null:
		hand.add_card(card)
		emit_signal("card_created")
		card.in_hand()
		


func _on_button_pressed():
	create_card('water')


func card_placed_in_hand(hand: Hand, card: Card):
	if card.is_in_hand:
		card.hand_ref.remove_card(card)
	elif card.is_in_fuser:
		card.fuser_ref.remove_card(card)
	card.in_hand()
	hand.add_card(card)


func card_placed_in_fuser(fuser: Fuser, card: Card):
	# Let's store where the card is coming from
	var original_object = card.home_object
	print(original_object)
	
	# First, let's check if we're being added to a depisotier
	if fuser.is_deposit:
		if fuser.check_deposit(card):
			# The else case is handled automatically
			pass
	elif (global.mana >= card.mana_cost):
		print('Added card from hand')
		if fuser.add_card(card):
			global.mana -= card.mana_cost
			update_mana()
			card.in_fuser()
	else:
		print("Whoops, I decided you need mana to move from fusers >:)")
		#fuser.add_card(card)
	
		
		# Let's check the 


func OLD_card_placed_in_fuser(fuser: Fuser, card: Card):
	var return_card = true
	
	if card.is_in_hand:
		print('card was in hand')
		card.hand_ref.remove_card(card)
	elif card.is_in_fuser:
		print('card was in fuser')
		card.fuser_ref.remove_card(card)
	
	
	# Make sure the card CAN be added to the fuser, if not return
	if fuser.add_card(card):
		if card.is_in_hand and !fuser.is_deposit:
			if global.mana >= card.mana_cost:
				global.mana -= card.mana_cost
				update_mana()
				return_card = false
				card.in_fuser()
		elif fuser.is_deposit:
			if fuser.check_deposit(card):
				print('Added to deposit')
				return_card = false
				card.in_fuser()
			else:
				print('Else reached')
		else:
			return_card = false
			card.in_fuser()
		
	if return_card:
		print('Should return card')
		card.home_object.add_card(card)
		#if card.is_in_hand:
		#	card.hand_ref.add_card(card)
		#elif card.is_in_fuser:
		#	card.fuser_ref.add_card(card)
	


func _on_button_2_pressed():
	create_card('fire')


func _on_button_3_pressed():
	create_card('boiling_water')


func _on_button_4_pressed():
	create_card($TextEdit.text.to_lower().to_snake_case())


func _on_button_5_pressed():
	clear_play_area()


func _on_button_6_pressed():
	global.current_level = 0
	load_level()


func _on_button_7_pressed():
	global.current_level = 1
	load_level()


func _on_end_turn_pressed():
	end_turn()


func _on_button_8_pressed():
	global.current_level = 2
	load_level()


func _on_restart_pressed():
	reset_level()


func _on_button_9_pressed():
	global.current_level = 3
	load_level()


func _on_button_10_pressed():
	global.current_level = len(global.levels)-1
	load_level()


func _on_hint_button_pressed():
	%Combinations.visible = !%Combinations.visible
	emit_signal("hint_clicked")
