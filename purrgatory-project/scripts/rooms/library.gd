extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('oliver_why'):
		state['oliver_why'] = false
	
	if state.get('_inv_ladder') and not state.get('oliver_asked_about_ladder'):
		state['oliver_asked_about_ladder'] = true
		# if oliver's here and you've met him...
		if not (state.get('oliver_why') or state.get('drama_ongoing') or state.get('oliver_in_study'))\
		and state.get('met_oliver'):
			emit_signal('start_dialog', 'oliver_ladder', [$oliver_idle])
	
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
