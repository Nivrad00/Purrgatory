extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('oliver_why'):
		$oliver_study.hide()
	else:
		$oliver_study.show()
		
	if state.get('tori_go_to_study'):
		state['tori_go_to_study'] = false
		emit_signal('set_hidden_sprite', [$oliver_study])