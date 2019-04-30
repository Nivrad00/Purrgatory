extends Node2D

export var default_room = ''

var state = {
	'true': true,
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

func _ready():
	randomize()
	change_room(default_room)
	var f = File.new()
	f.open("res://scripts/procgen/meowkov.json", File.READ)
	meowkov_json = JSON.parse(f.get_as_text())

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

func set_state(key, value):
	state[key] = value

func get_state(key):
	if key in state:
		return state[key]
	else:
		state[key] = false
		return false

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
		set_state(pair[0], pair[1])	
	$room.update_state(state)
	
func end_dialog():
	$ui.hide_ui()
	$room.end_dialog()

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
			set_state(pair[0], pair[1])	
		$room.update_state(state)

func set_player_name():
	format_dict['player'] = $ui/name_input/text.get_text().to_lower()
