extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('unlocked_commons_door'):
		$commons_door_exit.show()
		$commons_door_dialog.hide()
	else:
		$commons_door_exit.hide()
		$commons_door_dialog.show()