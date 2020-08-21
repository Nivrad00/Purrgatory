extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	$bg.hide()
	$bg2.hide()
	$dropoff_pit.hide()
	$dropoff_transition.hide()
	
	if state.get('preparing_for_climb') and not state.get('tori_dropoff_complete'):
		$dropoff_transition.show()
		$bg2.show()
	else:
		$dropoff_pit.show()
		$bg.show()