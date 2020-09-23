extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if state.get('elijah_sean_bench_timer'):
		state['elijah_sean_bench_timer'] = false
		emit_signal('start_action_timer', 40, ['elijah_sean_left_bench', true])