extends Node2D

var state = {}

var block = null
var default_room = 'room1'

func _ready():
	change_room(default_room)
	
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
	$ui.show()
	$room.disable_all()
		
	block = $dialog_handler.get_block(label, state)
	
	var branching_text = []
	for branch in block.branches:
		branching_text.append(branch[0])
	$ui.update_ui(block.speaker, block.sprites, block.text, branching_text)
	
	for pair in block.states:
		set_state(pair.state, pair.value)	
	$room.update_state(state)
	
func end_dialog():
	$ui.hide()
	$room.enable_all()

func update_dialog(b: int):
	if b == -1:
		block = $dialog_handler.get_block(block.next, state)
	else:
		block = $dialog_handler.get_block(block.branches[b][1], state)
		
	if block == null:
		$room.update_state(state)
		end_dialog()
	else:
		var branching_text = []
		for branch in block.branches:
			branching_text.append(branch[0])
		$ui.update_ui(block.speaker, block.sprites, block.text, branching_text)
		
		for pair in block.states:
			set_state(pair.state, pair.value)	
		$room.update_state(state)