extends 'state_handler_template.gd'
	
func play_default_music(state):
	if state.get('postgame'):
		emit_signal('change_audio', '')
	elif state.get('called_lucifur'):
		emit_signal('change_audio', 'Lucifur')
	else:			
		emit_signal('change_audio', default_music)
		
func update_state(state):
	.update_state(state)
	
	if state.get('postgame'):
		$exit2_end.show()
		$exit2.hide()
	else:
		$exit2_end.hide()
		$exit2.show()
