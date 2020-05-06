extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('elijah_went_to_sleep') and not state.get('elijah_woke_up'):
		$elijah_asleep.show()
	else:
		$elijah_asleep.hide()