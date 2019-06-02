extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if get_value('trample_flag', state):
		state['trample_flag'] = false