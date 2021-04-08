extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('oliver_why'):
		state['oliver_why'] = false
	
func update_state(state):
	.update_state(state)
	if state.get('oliver_why') or state.get('drama_ongoing') or state.get('oliver_in_study'):
		$oliver_idle.hide()
	else:
		$oliver_idle.show()
		
	if state.get('oliver_goto_commons'):
		emit_signal('change_room', 'commons1')

	if state.get('display_oliver'):
		emit_signal('set_hidden_sprite', [$oliver_idle])
		state['display_oliver'] = false
