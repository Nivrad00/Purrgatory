extends Node2D

signal return_to_main()

export var default_room = ''

var state = {
	'true': true
}

var _state = {
	'true': true,
	'unlocked_commons_door': true,
	'unlocked_meowseum_door': true,
	'_inv_business_card': true,
	'numa_at_commons': true
}

var tori_test_state = {
	'true': true,
	'saw_tori_intro': true,
	'met_tori': true,
	'tori_train_complete': true,
	'tori_park_complete': true#,
	#'tori_closet_complete': true
}

var sean_test_state = {
	'true': true,
	'met_sean': true,
	'sean_went_to_piano': true #,
	# '_inv_battery1': true,
	# '_inv_battery2': true
}

var natalie_test_state = {
	'true': true,
	'saw_natalie_intro': true,
	'returned_draw_a_paw': true,
	'natalie_finished_drawing3': true,
	'natalie_completed_mural': true,
	'natalie_working_on_nocturnal': true
}

var oliver_test_state = {
	'met_natalie': true,
	'true': true,
	'fed_kyungsoon_book': true,
	'met_kyungsoon': true,
	'met_oliver': true,
	'asked_ks_about_door': true,
	'checked_out_book': true,
	'tried_door': true,
	'book_state': true,
	'oliver_questioned': true,
	'_inv_commons_key': true,
	'seen_study': true,
	'_inv_chess_letter': true# ,
	# 'tori_visited_oliver': true,
	# 'oliver_asked_for_soda': true,
	# 'house_cat_pushed_glass': true,
	# 'comforted_oliver': true,
	# 'oliver_in_study': false
}

var numa_test_state = {
	'true': true,
	'fed_kyungsoon_book': true,
	'met_kyungsoon': true,
	'met_oliver': true,
	'asked_ks_about_door': true,
	'checked_out_book': true,
	'tried_door': true,
	'_inv_commons_key': true,
	'unlocked_commons_door': true,
	'met_numa': true,
	'numa_helping': true,
	'numa_snooped': true,
	'numa_started_poem': true,
	'numa_finished_poem': true,
	'numa_started_flowers': true,
	'flower_fails': 0,
	'numa_finished_flowers': true,
	'numa_started_food': true,
	'numa_progressed_food': true,
	'numa_finished_food': true,
	'met_elijah': true, 
	'numa_quest_complete': true,
	'ks_quest_complete': true,
	'ks_at_commons': true,
	'numa_at_commons': true
}

var format_dict = {
	'player': '',
	'player_upper': '',
	'they': '',
	'them': '',
	'their': '',
	'theirs': '',
	'themself': ''
}

var block = null
var meowkov_json = null
var action_timers = []
var fade_out = false
var current_audio = null
var skip = false

# i'm nearing the end of my rope...
# below is some state that needs to be saved, but isn't strings or numbers
# basically the drawings
var mural_drawing = null
var draw_a_paw_drawing = null

var seen_blocks = []

onready var room = get_node('content/room')
onready var ui = get_node('content/ui')

func _ready():
	randomize() # seed random
	room.change_room(default_room, state, false) # load default room
	change_audio(null) # load default audio (none)

	# load meowkov chain (disabled for now, don't click on any books!)
	var f = File.new()
	# load_meowkov_chain(f)

	# interrupt the default quit behavior (see _notification())
	get_tree().set_auto_accept_quit(false)

	# load seen blocks
	if f.file_exists("user://seen_blocks.save"):
		f.open("user://seen_blocks.save", File.READ)
		seen_blocks = parse_json(f.get_line())
		f.close()
	
	# cursor
	Input.set_custom_mouse_cursor(load("res://assets/draw_cursor.png"), Input.CURSOR_HELP)

func load_meowkov_chain(f):
	f.open("res://scripts/procgen/meowkov.json", File.READ)
	meowkov_json = JSON.parse(f.get_as_text())
	f.close()

func _notification(what):
	# when the user quits...
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# save the changes to options
		# (i'm doing it here as well as when they press "back" in case they quit
		#   while on the options menu)
		
		# this won't trigger if the game crashes
		# so if you're in the options menu and the game crashes,
		#   you'll have to redo any changes you made
		# idk if it triggers if you force quit the game or shut off the computer
		
		# btw there's no need to save seen_blocks here bc it's saved as soon
		#   as it's altered
		
		if visible:
			$meta_ui/options_menu.save_options()
		else:
			get_node('../options_menu').save_options()

		get_tree().quit()

func _process(delta):
	if fade_out:
		var a = $white_cover.color.a
		if a == 1:
			fade_out = false
			$delay_timer.start()
			change_audio(null)

			AudioServer.set_bus_mute(0, true)
			yield($delay_timer, 'timeout')

			emit_signal('return_to_main')
			$white_cover.color = Color(1, 1, 1, 0)
			reset_state(true) # reset state and room
			$meta_ui/pause_menu.hide() # hide it directly instead of using close_pause_menu()
			# bc you're not returning to the game
			$meta_ui/exit_confirm.hide()
			$white_cover.hide()
			set_process(false)
		else:
			a = min(a + 2 * delta, 1)
			AudioServer.set_bus_volume_db(0, AudioServer.get_bus_volume_db(0) - 40 * delta)
			$white_cover.color = Color(1, 1, 1, a)

func start_action_timer(actions, callback):
	action_timers.append([actions, callback])

func increment_action_timers():
	var new_list = []
	for action_timer in action_timers:
		action_timer[0] = action_timer[0] - 1
		if action_timer[0] <= 0:
			state[action_timer[1][0]] = action_timer[1][1]
		else:
			new_list.append(action_timer)
	action_timers = new_list

func change_room(label):
	increment_action_timers()
	if label == '_prev':
		room.change_room(room.prev_room_label, state)
	elif label == room.get_current_room():
		pass
	else:
		room.change_room(label, state)
		
		# a little hack: going into the draw-a-paw minigame should close the inventory
		if label == "draw_a_paw" and $meta_ui/dropdown.items_shown:
			$meta_ui/dropdown.toggle_items() 

func start_dialog(label, blackout_label=null):
	$meta_ui/debug/Label.text = str(state)
	
	if state.get('blackout') and blackout_label:
		label = blackout_label
		
	block = $dialog_handler.get_block(label, state)
	ui.show_ui()
	$meta_ui/history_button2.hide()
	room.start_dialog()
	
	# handle skip stuff before updating the ui so it knows if it should TTS or not
	if seen_blocks.has(block['label']):
		enable_skip()
		if skip:
			skip()
	else:
		disable_skip()
		if skip:
			turn_off_skip()

	var choices_text = []
	for choice in block['choices']:
		choices_text.append(choice[0])
	var text = block['text']

	if text != null:
		text = text.format(format_dict)

		var regex = RegEx.new()
		regex.compile('{([^/]+)/([^}]+)}')
		if 'they' in format_dict and format_dict['they'] == 'they':
			text = regex.sub(text, '$1', true)
		else:
			text = regex.sub(text, '$2', true)
	
	var speaker = block['speaker']
	if speaker != null:
		var speaker_format_dict = { }
		for key in ['tori', 'sean', 'elijah', 'numa']:
			if state.get('met_' + key):
				speaker_format_dict[key] = key
			else:
				speaker_format_dict[key] = '???'
				
		speaker = speaker.format(speaker_format_dict)

	ui.update_ui(speaker, block['sprites'], text, choices_text)
	
	for pair in block['states']:
		state[pair[0]] = pair[1]
	room.update_state(state)
	
	for pair in block['states']:
		check_special_states(pair)
		
	yield(get_tree(), "idle_frame")
	room.stop_all_hovering()

func end_dialog():
	ui.hide_ui()
	$meta_ui/history_button2.show()
	room.end_dialog()
	block = null

# block = {
#    'text': 'hello i'm oliver',
#    'choices': [['what\'s up', 'oliver_whats_up'], ['..', 'oliver_sdflkjslf']]
#     ...
#    'next': 150
# }

# clicking the text box goes through this function, so that the player can't
# click through text while skipping.
# the skipper goes directly to update_dialog.
func update_dialog_button_clicked():
	if not skip:
		update_dialog(-1)

func update_dialog(b: int):
	$meta_ui/debug/Label.text = str(state)
	
	# mark the previous block as seen, and immediately write to file
	seen_blocks.append(block['label'])

	var f = File.new()
	f.open("user://seen_blocks.save", File.WRITE)
	f.store_line(to_json(seen_blocks))
	f.close()
		
	# if there's no choice, get the next block directly
	if b == -1:
		block = $dialog_handler.get_block(block['next'], state)
	# else if there's a choice, use the parameter to decide
	else:
		block = $dialog_handler.get_block(block['choices'][b][1], state)

	if block == null:
		end_dialog()
		if skip:
			turn_off_skip()
		$meta_ui/history.add_space()
		room.update_state(state, true) # mark it as an end
		
		for pair in state:
			check_special_states([pair, state[pair]])
			
	else:
		# handle skip stuff before updating the ui so it knows if it should TTS or not
		if seen_blocks.has(block['label']):
			enable_skip()
			if skip:
				skip()
		else:
			disable_skip()
			if skip:
				turn_off_skip()

		var choices_text = []
		for choice in block['choices']:
			choices_text.append(choice[0])
		var text = block['text']

		if text != null:
			text = text.format(format_dict)

			var regex = RegEx.new()
			regex.compile('{([^/]+)/([^}]+)}')
			if format_dict.get('they') == 'they':
				text = regex.sub(text, '$1', true)
			else:
				text = regex.sub(text, '$2', true)

		var speaker = block['speaker']
		if speaker != null:
			var speaker_format_dict = { }
			for key in ['tori', 'sean', 'elijah', 'numa']:
				if state.get('met_' + key):
					speaker_format_dict[key] = key
				else:
					speaker_format_dict[key] = '???'
					
			speaker = speaker.format(speaker_format_dict)
	
		ui.update_ui(speaker, block['sprites'], text, choices_text)
		
		for pair in block['states']:
			state[pair[0]] = pair[1]
		room.update_state(state)
		
		for pair in block['states']:
			check_special_states(pair)

func set_player_name():
	var text = ui.get_node('name_input/text').get_text().to_lower()
	if text.length() != 0:
		format_dict['player'] = text

		if ui.get_node('name_input/pronouns/they').pressed:
			state['_pronouns_they'] = true
			format_dict['they'] = 'they'
			format_dict['them'] = 'them'
			format_dict['their'] = 'their'
			format_dict['theirs'] = 'theirs'
			format_dict['themself'] = 'themself'

		elif ui.get_node('name_input/pronouns/she').pressed:
			state['_pronouns_she'] = true
			format_dict['they'] = 'she'
			format_dict['them'] = 'her'
			format_dict['their'] = 'her'
			format_dict['theirs'] = 'hers'
			format_dict['themself'] = 'herself'

		elif ui.get_node('name_input/pronouns/he').pressed:
			state['_pronouns_he'] = true
			format_dict['they'] = 'he'
			format_dict['them'] = 'him'
			format_dict['their'] = 'his'
			format_dict['theirs'] = 'his'
			format_dict['themself'] = 'himself'

		elif ui.get_node('name_input/pronouns/custom').pressed:
			state['_pronouns_custom'] = true
			var pronoun_inputs = ui.get_node('name_input/custom_pronouns')
			format_dict['they'] = pronoun_inputs.get_node('they').text
			format_dict['them'] = pronoun_inputs.get_node('them').text
			format_dict['their'] = pronoun_inputs.get_node('their').text
			format_dict['theirs'] = pronoun_inputs.get_node('theirs').text
			format_dict['themself'] = pronoun_inputs.get_node('them').text + 'self'
			
		ui.get_node('name_input').hide()
		ui.get_node('text_box').disabled = false
		update_dialog(-1)

func change_audio(song, play = true):
	if AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
	
	if state.get('blackout_music'):
		song = 'Lights_Out'
		
	if song == current_audio:
		return

	current_audio = song

	if song == null or song == '':
		$main_audio.stop()
		$main_audio.set_stream(null)
	
	else:
		var stream = load('res://assets/audio/' + song + '.ogg')
		$main_audio.volume_db = -5
		$main_audio.set_stream(stream)
		$main_audio.set_bus('Music')

		if play:
			$main_audio.play()

func return_to_main():
	$white_cover.show()
	set_process(true)
	fade_out = true

func save(file):
	# save the drawings separately, if they exist
	# if the player is in the middle of drawing when they save, we have to retrieve the
	#   image first
	# (this is why we save images before the state: draw_a_paw needs to modify the state
	#  to store the x and y coordinates of the tip)
	
	if room.get_current_room() == "hallway2" and state.get('mural_drawing'): 
		room.current_room.get_node('state_handler').store_image()
		
	if mural_drawing:
		mural_drawing.save_png("user://mural" + str(file) + ".png")
	else:
		var dir = Directory.new()
		if dir.file_exists("user://mural" + str(file) + ".png"):
			dir.remove("user://mural" + str(file) + ".png")
	
	if room.get_current_room() == 'draw_a_paw':
		room.current_room.get_node('state_handler').store_image()
	
	if draw_a_paw_drawing:
		draw_a_paw_drawing.save_png("user://draw_a_paw" + str(file) + ".png")
	else:
		var dir = Directory.new()
		if dir.file_exists("user://draw_a_paw" + str(file) + ".png"):
			dir.remove("user://draw_a_paw" + str(file) + ".png")
	
	# also, if the player saved in the middle of ttt, it needs to be saved separately
	
	if room.get_current_room() == 'ttt':
		room.current_room.get_node('state_handler').save_ttt(file)
	else:
		var dir = Directory.new()
		if dir.file_exists("user://ttt_state" + str(file) + ".save"):
			dir.remove("user://ttt_state" + str(file) + ".save")
		if dir.file_exists("user://ttt_drawing" + str(file) + ".png"):
			dir.remove("user://ttt_drawing" + str(file) + ".png")
	
	# and flowerbed
	
	if room.get_current_room() == 'flowerbed' and state.get('flower_ongoing'):
		var state_handler = room.current_room.get_node('state_handler')
		state['flower_progress'] = state_handler.get_node('flower_progress').i
		state['flower_time_left'] = state_handler.get_node('game_timer').time_left
	else:
		state['flower_progress'] = null
		state['flower_time_left'] = null
		
	# and climb
	
	if room.get_current_room() == 'dropoff_long':
		var state_handler = room.current_room.get_node('state_handler')
		state['dropoff_climbing'] = state_handler.climbing
		state['dropoff_lost_grip'] = state_handler.lost_grip
		state['dropoff_progress'] = state_handler.progress
		state['dropoff_stamina'] = state_handler.get_node('_game/ProgressBar').value
	else:
		state['dropoff_climbing'] = null
		state['dropoff_lost_grip'] = null
		state['dropoff_progress'] = null
		state['dropoff_stamina'] = null
			
	# get the timestamp
	var months = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']
	var ampm = ['am', 'pm']
	var datetime = OS.get_datetime()

	var format = '%s %d, %d - %d:%02d %s'
	var timestamp = format % [
		months[datetime['month'] - 1],
		datetime['day'],
		datetime['year'],
		datetime['hour'] % 12,
		datetime['minute'],
		ampm[datetime['hour'] / 12]
	]

	# make a dict
	var save_dict = {
		"state_dict": state,
		"room": room.get_current_room(),
		"prev_room": room.prev_room_label,
		"block": block,
		"format_dict": format_dict,
		"action_timers": action_timers,
		"sprites": ui.get_sprites(),
		"choices": ui.get_choices(),
		"text": ui.get_text(),
		"speaker": ui.get_speaker(),
		"hidden_sprites": room.get_hidden_sprites(),
		"music": current_audio,
		"timestamp": timestamp,
		"history": $meta_ui/history.history,
		"inventory": $meta_ui/dropdown.get_inv_list(),
		"quest_log": $meta_ui/dropdown.get_quest_log()
	}

	# save a dict
	var save_game = File.new()
	save_game.open("user://save" + str(file) + ".save", File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()
			
	var dark_covers = $content/dark_covers
	
	# take a screenshot by moving all the relevant nodes to the "ss" viewport
	$content.remove_child(room)
	$content.remove_child(dark_covers)
	$content.remove_child(ui)
	$ss.add_child(room)
	$ss.add_child(dark_covers)
	$ss.add_child(ui)
	var neg = $negative_cover.duplicate()
	$ss.add_child(neg)
	$ss_tex.show()

	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	# grab the texture from the "ss" viewport
	var img = $ss.get_texture().get_data()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	img.save_png("user://thumb" + str(file) + ".png")

	# then move the nodes back
	$ss.remove_child(room)
	$ss.remove_child(dark_covers)
	$ss.remove_child(ui)
	$ss.remove_child(neg)
	$content.add_child(room)
	$content.add_child(dark_covers)
	$content.add_child(ui)
	$ss_tex.hide()

	# ok done
	$meta_ui/save_menu.hide()
	$meta_ui/save_confirm.show()

func load_game_while_playing(file):
	load_game(file)
	$main_audio.play()
	$meta_ui/load_menu.hide()
	$meta_ui/load_confirm.show()

func load_game(file):
	var save_game = File.new()
	if not save_game.file_exists("user://save" + str(file) + ".save"):
		return

	# temporarily mute audio to prevent artifacts
	AudioServer.set_bus_mute(0, true)
	
	save_game.open("user://save" + str(file) + ".save", File.READ)
	var save_dict = parse_json(save_game.get_line())
	save_game.close()

	reset_state(false) # reset state, but don't mess with the room
	# (resetting the room to the default and then immediately changing it to the new room was
	#   causing a bug where the defulut room didn't get deleted)
	state = save_dict["state_dict"]
	format_dict = save_dict["format_dict"]
	action_timers = save_dict["action_timers"]
	block = save_dict["block"]
	
	# drawings need to be loaded separately
	
	var f = File.new()
	if f.file_exists("user://mural" + str(file) + ".png"):
		mural_drawing = Image.new()
		mural_drawing.load("user://mural" + str(file) + ".png")
	else:
		mural_drawing = null
		
	if f.file_exists("user://draw_a_paw" + str(file) + ".png"):
		draw_a_paw_drawing = Image.new()
		draw_a_paw_drawing.load("user://draw_a_paw" + str(file) + ".png")
	else:
		draw_a_paw_drawing = null

	# ok back to room stuff
	
	room.change_room(save_dict["room"], state, false, true)
	change_audio(save_dict["music"], false)
	room.set_hidden_sprites(save_dict["hidden_sprites"])
	room.update_state(state)
	
	room.prev_room_label = save_dict["prev_room"]

	if block:
		ui.show_ui()
		$meta_ui/history_button2.hide()
		room.start_dialog()
		ui.update_ui(save_dict["speaker"], save_dict["sprites"], save_dict["text"], save_dict["choices"], false)
		print(save_dict["sprites"])

	$meta_ui/dropdown.load_inv(save_dict["inventory"])
	$meta_ui/dropdown.load_quest_log(save_dict["quest_log"])
	
	# wait until the ui is done updating so it doesn't interfere with the history
	yield(get_tree(), 'idle_frame')
	$meta_ui/history.load_history(save_dict["history"])
	
	if ui.visible:
		# wait again to make sure that stop_all_hovering takes place AFTER any hovering
		yield(get_tree(), "idle_frame")
		room.stop_all_hovering()
	
	yield(get_tree(), "idle_frame")
	AudioServer.set_bus_mute(0, false)
	
	# finally, if the player loaded into ttt, it needs to be loaded separately
	if room.get_current_room() == 'ttt':
		room.current_room.get_node('state_handler').load_ttt(file)
		
	# flowerbed just needs a little push
	if room.get_current_room() == 'flowerbed':
		room.current_room.get_node('state_handler').setup_game()
		if state.get('flower_ongoing'):
			var progress = 0
			var time = 0
			
			if state.get('flower_progress'):
				progress = state['flower_progress']
			if state.get('flower_time_left'):
				time = state['flower_time_left']
				
			room.current_room.get_node('state_handler').start_game(time, progress)
	
	# and climbing
	if room.get_current_room() == 'dropoff_long':
		room.current_room.get_node('state_handler').load_in(\
			state.get('dropoff_climbing'),\
			state.get('dropoff_lost_grip'),\
			state.get('dropoff_progress'),\
			state.get('dropoff_stamina')\
		)
			
func reset_state(reset_room):
	end_dialog()
	
	ui.get_node('name_input').hide()
	ui.get_node('name_input/text').set_text('')
	ui.get_node('name_input/pronouns/they').pressed = true
	
	ui.get_node('name_input/custom_pronouns').hide()
	ui.get_node('name_input/custom_pronouns/they').text = "they"
	ui.get_node('name_input/custom_pronouns/them').text = "them"
	ui.get_node('name_input/custom_pronouns/their').text = "their"
	ui.get_node('name_input/custom_pronouns/theirs').text = "theirs"
	
	state = {
		'true': true
	}
	format_dict = {
		'player': '',
		'player_upper': ''
	}
	
	action_timers = []
	if reset_room:
		room.change_room(default_room, state, false)
	change_audio(null)
	
	$meta_ui/dropdown.load_inv([])
	$meta_ui/dropdown.load_quest_log([])
	$meta_ui/history.load_history([])

func open_pause_menu():
	$tts_node.stop()
	$meta_ui/pause_menu.show_custom()

func close_pause_menu():
	if ui.is_visible():
		ui.speak_ui()
	$meta_ui/pause_menu.hide()

func options_changed():
	var state_handler = room.find_node('state_handler', true, false)
	if state_handler and state_handler.has_method('options_changed'):
		state_handler.options_changed()

func save_confirmed():
	$meta_ui/save_confirm.hide()
	close_pause_menu()

func load_confirmed():
	$meta_ui/load_confirm.hide()
	close_pause_menu()

func toggle_skip():
	if ui.get_node('skip_button/x').visible:
		return
	if skip:
		turn_off_skip()
	else:
		turn_on_skip()

func turn_off_skip():
	skip = false
	ui.get_node('skip_button/box2').set_modulate(Color(1, 1, 1))
	$skip_timer.stop()

func turn_on_skip():
	skip = true
	ui.get_node('skip_button/box2').set_modulate(Color(0.85, 0.85, 0.85))
	skip()

func enable_skip():
	ui.get_node('skip_button/x').hide()
	ui.get_node('skip_button').mouse_default_cursor_shape = Input.CURSOR_POINTING_HAND	

func disable_skip():
	ui.get_node('skip_button/x').show()
	ui.get_node('skip_button').mouse_default_cursor_shape = Input.CURSOR_ARROW

func skip():
	if block['choices'].size() == 0 and (block['states'].size() == 0 or block['states'][0][0] != 'no_skip'):
		# no_skip is used to prevent it from skipping the name input
		$skip_timer.start()

# examine an item from the inventory
func examine_item(_name):
	if not ui.is_visible():
		start_dialog('examine_' + _name)

func check_special_states(pair):
	if pair[0].substr(0,  5) == '_inv_':
		if pair[1]:
			$meta_ui/dropdown.add_to_inv(pair[0].substr(5, len(pair[0])))
		else:
			$meta_ui/dropdown.remove_from_inv(pair[0].substr(5, len(pair[0])))

	if pair[0].substr(0,  7) == '_quest_':
		if pair[1]:
			$meta_ui/dropdown.add_quest(pair[0].substr(7, len(pair[0])))
		else:
			$meta_ui/dropdown.remove_quest(pair[0].substr(7, len(pair[0])))

	if pair[0].substr(0,  6) == '_anim_' and pair[1]:
		state[pair[0]] = false

		var player = ui.get_node('AnimationPlayer')
		var anim = pair[0].substr(6, len(pair[0]))

		if player.has_animation(anim):
			player.play(anim)
		else:
			print('uh oh stinky this anim is missing: %s' % anim)

func test_add_quest():
	check_special_states([$meta_ui/dropdown/quest_debug.text, true])

func test_remove_quest():
	check_special_states([$meta_ui/dropdown/quest_debug.text, false])

# this is called from the save/load screens when you delete your data
# just so that we can delete seen_blocks
func deleted_data():
	seen_blocks = []