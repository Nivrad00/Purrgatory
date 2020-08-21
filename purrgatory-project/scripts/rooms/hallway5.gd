extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	
	# if you just got done with oliver's date, you can clear the override thing now
	if state.get('oliver_override_dropoff'):
		state['oliver_override_dropoff'] = false
	
func update_state(state):
	.update_state(state)
	if state.get('oliver_goto_dropoff3'):
		state['oliver_goto_dropoff3'] = false
		emit_signal('change_room', 'dropoff1')