extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	if get_value('elijah_goto_garden', state):
		emit_signal('change_room', 'garden6')
		state['elijah_goto_garden'] = false
		
	if get_value('display_elijah_and_sean', state):
		emit_signal('set_hidden_sprite', [$elijah_idle, $sean_idle])
		state['display_elijah_and_sean'] = false
		
	if get_value('display_sean', state):
		emit_signal('set_hidden_sprite', [$sean_idle])
		state['display_sean'] = false