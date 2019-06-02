extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('oliver_why'):
		state['oliver_why'] = false
	
func update_state(state):
	.update_state(state)
	if state.get('oliver_why') or state.get('drama_ongoing'):
		$oliver_idle.hide()
	else:
		$oliver_idle.show()