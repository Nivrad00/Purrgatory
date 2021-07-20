extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if state.get('_inv_draw_a_paw') or state.get('returned_draw_a_paw'):
		$draw_a_paw.hide()
	
	$elijah_meowseum.hide()
	if state.get('opened_meowseum_door') and not state.get('sean_broke_sculpture'):
		$elijah_meowseum.show()
		
	# exception if elijah's off helping numa with her poem
	if state.get('poetry_session'):
		$elijah_meowseum.hide()
	
	# oliver's date overrides elijah
	if state.get('oliver_on_date'):
		$elijah_meowseum.hide()
		
	if state.get('oliver_goto_meowseum2'):
		state['oliver_goto_meowseum2'] = false
		emit_signal('change_room', 'meowseum4')
