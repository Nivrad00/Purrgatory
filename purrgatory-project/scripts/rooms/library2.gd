extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('_inv_snowglobe_library') or state.get('placed_snowglobes'):
		$snowglobe_library.hide()