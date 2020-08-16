extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if state.get('preparing_for_climb') and not state.get('tori_dropoff_complete'):
		$dropoff_pit.hide()
		$dropoff_transition.show()
	else:
		$dropoff_pit.show()
		$dropoff_transition.hide()