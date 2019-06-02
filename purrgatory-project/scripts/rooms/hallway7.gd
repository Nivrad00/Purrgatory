extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	var audio = get_node("../../../../main_audio")
	if not audio.is_playing():
		audio.play()