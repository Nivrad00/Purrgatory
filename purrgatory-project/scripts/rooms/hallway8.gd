extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	if state.get('elijah_goto_garden'):
		emit_signal('change_room', 'garden6')
		state['elijah_goto_garden'] = false
		
	if state.get('display_elijah_and_sean'):
		emit_signal('set_hidden_sprite', [$elijah_idle, $sean_idle])
		state['display_elijah_and_sean'] = false
		
	if state.get('display_sean'):
		emit_signal('set_hidden_sprite', [$sean_idle])
		state['display_sean'] = false
		
	if state.get('display_elijah'):
		emit_signal('set_hidden_sprite', [$elijah_idle])
		state['display_elijah'] = false