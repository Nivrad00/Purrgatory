extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('house_natalie_heard_glass'):
		state['house_natalie_heard_glass'] = false
		
		if state.get('met_natalie'):
			emit_signal('start_dialog', 'natalie_glass', [])
		
	if state.get('sean_replaced_batteries') or state.get('_inv_battery2'):
		$battery2.hide()
		