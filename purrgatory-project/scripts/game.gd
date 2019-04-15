extends Node2D

export var default_room = ''

var state = {
	'true': true
}

var block = null
var meowkov_json = null

func _ready():
	randomize()
	change_room(default_room)
	var f = File.new()
	f.open("res://scripts/procgen/meowkov.json", File.READ)
	meowkov_json = JSON.parse(f.get_as_text())
	
func change_room(label):
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
	
	# block = {
	#   'speaker': string,
	#   'sprites': [string],
	#   'text': string,
	#   'choices': [['nice to meet you', 'kyungsoon_meet'], ['are you ok?', 'kyungsoon_ok']],
	#   'states': [['met_kyungsoon', true], ['sdfkjsfd', false]],
	#   'next': null
	#   }
	
	var choices_text = []
	for choice in block['choices']:
		choices_text.append(choice[0])
	$ui.update_ui(block['speaker'], block['sprites'], block['text'], choices_text)
	
	for pair in block['states']:
		set_state(pair[0], pair[1])	
	$room.update_state(state)
	
func end_dialog():
	$ui.hide_ui()
	$room.end_dialog()

func update_dialog(b: int):
	if b == -1:
		block = $dialog_handler.get_block(block['next'], state)
	else:
		block = $dialog_handler.get_block(block['choices'][b][1], state)
		
	if block == null:
		end_dialog()
		$room.update_state(state)
	else:
		var choices_text = []
		for choice in block['choices']:
			choices_text.append(choice[0])
		$ui.update_ui(block['speaker'], block['sprites'], block['text'], choices_text)
		
		for pair in block['states']:
			set_state(pair[0], pair[1])	
		$room.update_state(state)