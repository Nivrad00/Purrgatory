extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('oliver_goto_ttt'):
		state['oliver_goto_ttt'] = false
		emit_signal('change_room', 'ttt')
		
	if state.get('oliver_sleeping_timer'):
		state['oliver_sleeping_timer'] = false
		emit_signal('start_action_timer', 50, ['oliver_sleeping', false])
		emit_signal('start_action_timer', 50, ['oliver_in_study', false])
	
	if state.get('elijah_quest_complete') and not state.get('elijah_sean_left_bench'):
		$elijah_and_sean_bench.show()
	else:
		$elijah_and_sean_bench.hide()