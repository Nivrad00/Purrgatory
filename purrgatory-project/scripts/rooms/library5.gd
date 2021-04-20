extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if state.get('took_ladder'):
		$ladder2.hide()
	else:
		$ladder2.show()