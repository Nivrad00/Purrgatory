extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if get_node('../../..').prev_room_label == "hallway14" and not state.get('lowered_drawbridge'):
		state['lowered_drawbridge'] = true
	
	$drawbridge_up.hide()
	$drawbridge_down.hide()
	$far_exit.hide()
	$far_exit_dialog.hide()
	
	if state.get('lowered_drawbridge'):
		$drawbridge_down.show()
		$far_exit.show()
	else:
		$drawbridge_up.show()
		$far_exit_dialog.show()