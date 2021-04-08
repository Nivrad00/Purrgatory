extends 'state_handler_template.gd'

func play_default_music(state):
	if state.get('postgame'):
		emit_signal('change_audio', '')
	else:			
		emit_signal('change_audio', default_music)
