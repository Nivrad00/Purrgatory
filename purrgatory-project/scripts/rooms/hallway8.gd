extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	$elijah_idle.show()
	$sean_idle.show()
	
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
		
	if state.get('opened_meowseum_door'):
		$sean_idle.hide()
	
	if state.get('opened_meowseum_door') or state.get('poetry_session'):
		$elijah_idle.hide()
	
	# pretty sure this isn't used since elijah's question was rewritten
	for key in state.keys():
		# template: _madlib1_orange
		if key.substr(0, 7) == '_madlib' and state[key]:
			state[key] = false
			var format_key = key.substr(1, 7)
			var format_value = key.substr(9, key.length()-1)
			get_node('../../../../..').format_dict[format_key] = format_value
