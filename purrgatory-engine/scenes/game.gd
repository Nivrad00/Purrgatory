extends Node2D

var state = {
	'global': {},
	'room': {},
	'character': {}
}

var block = null

func set_state(state, value):
	pass

func get_state(state, value):
	pass

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
	
func end_dialog():
	$ui.hide()
	$room.enable_all()

func update_dialog(b: int):
	if b == -1:
		block = $dialog_handler.get_block(block.next, state)
	else:
		block = $dialog_handler.get_block(block.branches[b][1], state)
		
	if block == null:
		end_dialog()
	else:
		var branching_text = []
		for branch in block.branches:
			branching_text.append(branch[0])
		$ui.update_ui(block.speaker, block.sprites, block.text, branching_text)
		for pair in block.states:
			set_state(pair.state, pair.value)	