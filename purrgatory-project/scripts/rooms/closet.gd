extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('tori_park_complete') and not state.get('tori_closet_complete'):
		$tori_closet.show()
	else:
		$tori_closet.hide()