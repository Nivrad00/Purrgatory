extends 'state_handler_template.gd'

var state = null

func update_state(_state):
	.update_state(_state)
	state = _state
	
	if state.get('start_skip_timer') and $shelf/Timer.time_left == 0:
		$shelf/Timer.start()
	
	if state.get('tori_closet_complete'):
		state['start_skip_timer'] = false

func disconnected_wire():
	$disconnect.play()
	
func connected_node():
	$connect.play()
	
	if not state.get('blackout'):
		state['blackout'] = true
		get_node('../../../../../content/dark_covers/dark').show()
		$power_down.play()
		$cover.show()
		emit_signal('change_audio', null)
		$GridContainer.release_wire()
		
		$power_delay.start()
		yield($power_delay, "timeout")
		
		emit_signal('start_dialog', 'tori_wire_blackout', [])
	
	var solved = true
	
	for button in $GridContainer.get_children():
		var letter = button.get_node('Label').text
		if letter != '' and (not button.origin or button.origin.get_node('Label').text != letter):
			solved = false
	
	if solved:
		state['blackout'] = false
		get_node('../../../../../content/dark_covers/wire_game').hide()
		$power_on.play()
		$cover.show()
		$GridContainer.release_wire()
		
		$power_delay.start()
		yield($power_delay, "timeout")
		
		emit_signal('start_dialog', 'tori_wire_success', [])
		$shelf/Timer.stop()

func skip():
	state['blackout'] = false
	get_node('../../../../../content/dark_covers/wire_game').hide()
	$power_down.play()
	$cover.show()
	$GridContainer.release_wire()
	yield($power_down, "finished")
	emit_signal('start_dialog', 'tori_wire_skip', [])
