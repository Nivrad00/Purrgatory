extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	emit_signal('change_audio', 'fly me to the meow')