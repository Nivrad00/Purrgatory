extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	state['saw_dropoff'] = true
	
func update_state(state):
	.update_state(state)
	if state.get('oliver_goto_ttt'):
		state['oliver_goto_ttt'] = false
		emit_signal('change_room', 'ttt')
	
	if state.get('oliver_sleeping_timer'):
		state['oliver_sleeping_timer'] = false
		emit_signal('start_action_timer', 50, ['oliver_sleeping', false])
		emit_signal('start_action_timer', 50, ['oliver_in_study', false])