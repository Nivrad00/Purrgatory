extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('trample_flag'):
		state['trample_flag'] = false
