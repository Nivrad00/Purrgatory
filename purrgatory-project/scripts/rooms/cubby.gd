extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	state['numa_snooped'] = true
