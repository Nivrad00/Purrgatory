extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('tori_go_to_study'):
		emit_signal('change_room', 'study')