extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if state.get('broke_vending_machine'):
		$crowbar.hide()
	else:
		$crowbar.show()