extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('house_natalie_heard_glass'):
		state['house_natalie_heard_glass'] = false
		state['cat_in_house'] = false
		
		# natalie shows up if you've met her AND if she's not at the slam
		if state.get('met_natalie') and not state.get('looking_for_poem'):
			emit_signal('start_dialog', 'natalie_glass', [])

func update_state(state):
	.update_state(state)
	if state.get('sean_replaced_batteries') or state.get('_inv_battery2'):
		$battery2.hide()
		