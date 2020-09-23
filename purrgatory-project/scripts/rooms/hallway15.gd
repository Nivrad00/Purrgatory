extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if get_node('../../..').prev_room_label == "house1" and not state.get('opened_house'):
		state['opened_house'] = true
	
	$door_dialog.hide()
	$door_exit.hide()
	
	if state.get('opened_house'):
		$door_exit.show()
	else:
		$door_dialog.show()
	
	if state.get('ding_dong'):
		state['ding_dong'] = false
		$ding_dong.play()