extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	$bg.hide()
	$bg2.hide()
	$dropoff_rope1.hide()
	$dropoff_rope2.hide()
	$dropoff_pit.hide()
	$dropoff_transition.hide()
	
	if state.get('natalie_completed_mural') and not state.get('natalie_working_on_nocturnal'):
		$dropoff_pit.show()
		$bg.show()
	elif state.get('tori_closet_complete') and not state.get('preparing_for_climb'):
		$dropoff_pit.show()
		$bg2.show()
		$dropoff_rope1.show()
	elif state.get('preparing_for_climb') and not state.get('tori_dropoff_complete'):
		$dropoff_transition.show()
		$dropoff_rope2.show()
		$bg2.show()
	else:
		$dropoff_pit.show()
		$bg.show()
