extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('oliver_goto_ttt'):
		state['oliver_goto_ttt'] = false
		emit_signal('change_room', 'ttt')