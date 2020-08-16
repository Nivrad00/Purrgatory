extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if state.get('met_tori'):
		$tori_idle.hide()
	else:
		$tori_idle.show()