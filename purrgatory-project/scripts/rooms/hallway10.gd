extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('opened_meowseum_door'):
		$meowseum_door_exit.show()
		$meowseum_door_dialog.hide()
	else:
		$meowseum_door_exit.hide()
		$meowseum_door_dialog.show()