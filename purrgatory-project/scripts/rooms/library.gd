extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if get_value('oliver_why', state):
		state['oliver_why'] = false
	
func update_state(state):
	.update_state(state)
	if get_value('oliver_why', state) or get_value('drama_ongoing', state):
		$oliver_idle.hide()
	else:
		$oliver_idle.show()