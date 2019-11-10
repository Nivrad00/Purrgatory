extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('oliver_goto_dropoff3'):
		state['oliver_goto_dropoff3'] = false
		emit_signal('change_room', 'dropoff1')