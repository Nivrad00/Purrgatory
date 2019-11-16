extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('oliver_why'):
		$oliver_study.hide()
	else:
		$oliver_study.show()
	
	if state.get('oliver_sleeping'):
		$oliver_study.hide()
		$oliver_sleeping.show()
	elif state.get('oliver_in_study'):
		$oliver_study.show()
		$oliver_sleeping.hide()
	else:
		$oliver_study.hide()
		$oliver_sleeping.hide()
		
	if state.get('tori_goto_study'):
		state['tori_goto_study'] = false
		emit_signal('set_hidden_sprite', [$oliver_study])
		
	if state.get('oliver_goto_park1'):
		state['oliver_goto_park1'] = false
		emit_signal('change_room', 'field1')
		
	if state.get('oliver_goto_meowseum1'):
		state['oliver_goto_meowseum1'] = false
		emit_signal('change_room', 'meowseum2')
		
	if state.get('oliver_goto_dropoff1'):
		state['oliver_goto_dropoff1'] = false
		emit_signal('change_room', 'hallway4')