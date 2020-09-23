extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if state.get('suggested_code'):
		$door_exit.show()
		$door_dialog.hide()
	else:
		$door_exit.hide()
		$door_dialog.show()