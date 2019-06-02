extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	get_node("../../../../main_audio").stop()