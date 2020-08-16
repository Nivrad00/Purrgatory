extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	if state.get('_inv_draw_a_paw') or state.get('returned_draw_a_paw'):
		$draw_a_paw.hide()