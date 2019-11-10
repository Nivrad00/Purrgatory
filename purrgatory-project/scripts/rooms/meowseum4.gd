extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('oliver_goto_meowseum3'):
		state['oliver_goto_meowseum3'] = false
		emit_signal('change_room', 'meowseum1')