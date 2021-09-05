extends 'state_handler_template.gd'

func play_default_music(state):
	if state.get('postgame'):
		emit_signal('change_audio', '')
	else:			
		emit_signal('change_audio', default_music)
		
func update_state(state):
	.update_state(state)
	
	if state.get('ringing_bell'):
		$ringing.play()
		state['ringing_bell'] = false
	
	if state.get('ready_for_slam'):
		$bell_alt.show()
		$bell.hide()
	else:
		$bell_alt.hide()
		$bell.show()
