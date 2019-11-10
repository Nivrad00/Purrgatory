extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('house_natalie_heard_glass'):
		state['house_natalie_heard_glass'] = false
		emit_signal('start_dialog', 'natalie_glass', [])