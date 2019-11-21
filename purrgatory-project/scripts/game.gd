extends Node2D

signal return_to_main()

export var default_room = ''

var default_state = {
	'true': true,
}

var state = {
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
	'oliver_in_study': true,
	'seen_study': true,
	'_inv_chess_letter': true,
	'tori_visited_oliver': true,
	'oliver_asked_for_soda': true # ,
	# 'house_cat_pushed_glass': true
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

func _ready():
	randomize()
	$room.change_room(default_room, state, false)
	change_audio(null)
	var f = File.new()
	f.open("res://scripts/procgen/meowkov.json", File.READ)
	meowkov_json = JSON.parse(f.get_as_text())
	check_save()

func check_save():
	var save_game = File.new()
	if save_game.file_exists("user://save1.save"):
		$meta_ui/pause_menu/load/x.hide()
		$meta_ui/pause_menu/load.disabled = false
	else:
		$meta_ui/pause_menu/load/x.show()
		$meta_ui/pause_menu/load.disabled = true

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
			reset_state()
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
	increment_action_timers()
	$room.change_room(label, state)

func start_dialog(label):
	block = $dialog_handler.get_block(label, state)
	$ui.show()
	$room.start_dialog()
	
	var choices_text = []
	for choice in block['choices']:
		choices_text.append(choice[0])
	var text = block['text']
	if text != null:
		text = text.format(format_dict)
	$ui.update_ui(block['speaker'], block['sprites'], text, choices_text)
	
	for pair in block['states']:
		state[pair[0]] = pair[1]
	$room.update_state(state)
	
func end_dialog():
	$ui.hide_ui()
	$room.end_dialog()
	block = null

# block = {
#    'text': 'hello i'm oliver',
#    'choices': [['what\'s up', 'oliver_whats_up'], ['..', 'oliver_sdflkjslf']]
#     ...
#    'next': 150
# }

func update_dialog(b: int):	
	# if there's no choice, get the next block directly
	if b == -1:
		block = $dialog_handler.get_block(block['next'], state)
	# else if there's a choice, use the parameter to decide
	else:
		block = $dialog_handler.get_block(block['choices'][b][1], state)
		
	if block == null:
		end_dialog()
		$room.update_state(state)
	else:
		var choices_text = []
		for choice in block['choices']:
			choices_text.append(choice[0])
		var text = block['text']
		if text != null:
			text = text.format(format_dict)
		$ui.update_ui(block['speaker'], block['sprites'], text, choices_text)
		
		for pair in block['states']:
			state[pair[0]] = pair[1]
		$room.update_state(state)

func set_player_name():
	format_dict['player'] = $ui/name_input/text.get_text().to_lower()

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
	print('changed audio to ' + str(song))

func return_to_main():
	$white_cover.show()
	set_process(true)
	fade_out = true

func _on_save_pressed():
	save()
	$meta_ui/save_confirm.show()

func _on_load_pressed():
	load_game()
	$main_audio.play()
	$meta_ui/load_confirm.show()

func save():
	var save_dict = {
		"state_dict": state,
		"room": $room.get_current_room(),
		"block": block,
		"name_dict": format_dict,
		"action_timers": action_timers,
		"sprites": $ui.get_sprites(),
		"choices": $ui.get_choices(),
		"text": $ui.get_text(),
		"speaker": $ui.get_speaker(),
		"hidden_sprites": $room.get_hidden_sprites(),
		"music": current_audio
	}
	var save_game = File.new()
	save_game.open("user://save1.save", File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://save1.save"):
		return
		
	save_game.open("user://save1.save", File.READ)
	var save_dict = parse_json(save_game.get_line())
	save_game.close()
	
	reset_state()
	state = save_dict["state_dict"]
	format_dict = save_dict["name_dict"]
	action_timers = save_dict["action_timers"]
	block = save_dict["block"]
	
	$room.change_room(save_dict["room"], state, false)
	change_audio(save_dict["music"], false)
	$room.set_hidden_sprites(save_dict["hidden_sprites"])
	$room.update_state(state)
	
	if block:
		$ui.show()
		$room.start_dialog()
		$ui.update_ui(save_dict["speaker"], save_dict["sprites"], save_dict["text"], save_dict["choices"])
			
func reset_state():
	end_dialog()
	$ui/name_input.hide()
	$ui/name_input/text.set_text('')
	state = {
		'true': true
	}
	format_dict = {
		'player': '',
		'player_upper': ''
	}
	action_timers = []
	$room.change_room('reception', state, false)
	change_audio(null)

func open_pause_menu():
	$meta_ui/pause_menu.show()
	check_save()