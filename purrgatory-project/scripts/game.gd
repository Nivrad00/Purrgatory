extends Node2D

signal return_to_main()

export var default_room = ''

var state = {
	'true': true,
}

var oliver_test_state = {
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
	'_inv_chess_letter': true,
	'tori_visited_oliver': true,
	'oliver_asked_for_soda': true,
	'house_cat_pushed_glass': true,
	'comforted_oliver': true,
	'oliver_in_study': false
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
	'met_numa': true,
	'numa_helping': true,
	'numa_snooped': true,
	'numa_started_poem': true,
	'numa_finished_poem': true,
	'numa_started_flowers': true,
	'numa_finished_flowers': true,
	'numa_started_food': true,
	'numa_progressed_food': true,
	'numa_finished_food': true,
	'met_elijah': true
}

var format_dict = {
	'player': '',
	'player_upper': ''
}

var block = null
var meowkov_json = null
var action_timers = []
var fade_out = false
var current_audio = null
var skip = false

var seen_blocks = []

onready var room = get_node('content/room')
onready var ui = get_node('content/ui')

func _ready():
	randomize() # seed random
	room.change_room(default_room, state, false) # load default room
	change_audio(null) # load default audio (none)
	
	# load meowkov chain (disabled for now, don't click on any books!)
	var f = File.new()
	# load_meowkov_chain()
	
	# interrupt the default quit behavior (see _notification())
	get_tree().set_auto_accept_quit(false)
	
	# load seen blocks
	if f.file_exists("res://save_data/seen_blocks.save"):
		f.open("res://save_data/seen_blocks.save", File.READ)
		seen_blocks = parse_json(f.get_line())
		f.close()

func load_meowkov_chain(f):
	f.open("res://scripts/procgen/meowkov.json", File.READ)
	meowkov_json = JSON.parse(f.get_as_text())
	f.close()
	

func _notification(what):
	# when the user quits...
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# save seen_blocks to file
		# (that's the only time it needs to be saved, afaik)
		var f = File.new()
		f.open("res://save_data/seen_blocks.save", File.WRITE)
		f.store_line(to_json(seen_blocks))
		f.close()
		
		# also save options
		# (i'm doing it here instead of when they press "back" in case they quit
		#   while on the options menu)
		# (also these paths suck but whatever)
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
			
			$main_audio.volume_db = 0
			yield($delay_timer, 'timeout')
			
			emit_signal('return_to_main')
			$white_cover.color = Color(1, 1, 1, 0)
			reset_state(true) # reset state and room
			$meta_ui/pause_menu.hide()
			$meta_ui/exit_confirm.hide()
			$white_cover.hide()
			set_process(false)
		else:
			a = min(a + 2 * delta, 1)
			$main_audio.volume_db = $main_audio.volume_db - 40 * delta
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
	# print(state)
	increment_action_timers()
	room.change_room(label, state)

func start_dialog(label):
	block = $dialog_handler.get_block(label, state)
	ui.show()
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
	ui.update_ui(block['speaker'], block['sprites'], text, choices_text)
	
	for pair in block['states']:
		check_inv_and_quest_state(pair)
		state[pair[0]] = pair[1]
	room.update_state(state)
	
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

func update_dialog(b: int):
	# mark the previous block as seen
	seen_blocks.append(block['label'])
	
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
		room.update_state(state)
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
		ui.update_ui(block['speaker'], block['sprites'], text, choices_text)
		
		for pair in block['states']:
			check_inv_and_quest_state(pair)
			state[pair[0]] = pair[1]
		room.update_state(state)

func set_player_name():
	format_dict['player'] = ui.get_node('name_input/text').get_text().to_lower()

func change_audio(song, play = true):
	current_audio = song
	if song == null:
		$main_audio.stop()
		$main_audio.set_stream(null)
	else:
		var stream = load('res://assets/audio/' + song + '.ogg')
		if stream != $main_audio.get_stream():
			$main_audio.set_stream(stream)
			if play:
				$main_audio.play()

func return_to_main():
	$white_cover.show()
	set_process(true)
	fade_out = true

func save(file):
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
		"block": block,
		"name_dict": format_dict,
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
	save_game.open("res://save_data/save" + str(file) + ".save", File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()
	
	# take a screenshot by moving all the relevant nodes to the "ss" viewport
	$content.remove_child(room)
	$content.remove_child(ui)
	$ss.add_child(room)
	$ss.add_child(ui)
	$ss_tex.show()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	# grab the texture from the "ss" viewport
	var img = $ss.get_texture().get_data()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	img.save_png("res://save_data/thumb" + str(file) + ".png")
	
	# then move the nodes back
	$ss.remove_child(room)
	$ss.remove_child(ui)
	$content.add_child(room)
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
	if not save_game.file_exists("res://save_data/save" + str(file) + ".save"):
		return
		
	save_game.open("res://save_data/save" + str(file) + ".save", File.READ)
	var save_dict = parse_json(save_game.get_line())
	save_game.close()
	
	reset_state(false) # reset state, but don't mess with the room
	# (resetting the room to the default and then immediately changing it to the new room was 
	#   causing a bug where the defulut room didn't get deleted)
	state = save_dict["state_dict"]
	format_dict = save_dict["name_dict"]
	action_timers = save_dict["action_timers"]
	block = save_dict["block"]
	
	room.change_room(save_dict["room"], state, false)
	change_audio(save_dict["music"], false)
	room.set_hidden_sprites(save_dict["hidden_sprites"])
	room.update_state(state)
	
	if block:
		ui.show()
		$meta_ui/history_button2.hide()
		room.start_dialog()
		ui.update_ui(save_dict["speaker"], save_dict["sprites"], save_dict["text"], save_dict["choices"])
	
	$meta_ui/dropdown.load_inv(save_dict["inventory"])
	$meta_ui/dropdown.load_quest_log(save_dict["quest_log"])
	
	# wait until the ui is done updating so it doesn't interfere with the history
	yield(get_tree(), 'idle_frame')
	
	$meta_ui/history.load_history(save_dict["history"])
	
func reset_state(reset_room):
	end_dialog()
	ui.get_node('name_input').hide()
	ui.get_node('name_input/text').set_text('')
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

func open_pause_menu():
	$meta_ui/pause_menu.show()

func options_changed():
	var state_handler = room.find_node('state_handler', true, false)
	if state_handler.has_method('options_changed'):
		state_handler.options_changed()
	
func save_confirmed():
	$meta_ui/pause_menu.hide()
	$meta_ui/save_confirm.hide()

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

func turn_on_skip():
	skip = true
	ui.get_node('skip_button/box2').set_modulate(Color(0.9, 0.9, 0.9))
	skip()

func enable_skip():
	ui.get_node('skip_button/x').hide()

func disable_skip():
	ui.get_node('skip_button/x').show()
	
func skip():
	if block['choices'].size() == 0 and (block['states'].size() == 0 or block['states'][0][0] != 'no_skip'):
		# no_skip is used to prevent it from skipping the name input
		$skip_timer.start()

# examine an item from the inventory
func examine_item(_name):
	if not ui.is_visible():
		start_dialog('examine_' + _name)
	
func check_inv_and_quest_state(pair):
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
			
func test_add_quest():
	check_inv_and_quest_state([$meta_ui/dropdown/quest_debug.text, true])

func test_remove_quest():
	check_inv_and_quest_state([$meta_ui/dropdown/quest_debug.text, false])
