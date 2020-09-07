extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	if state.get('_inv_snowglobe_house') or state.get('spent_snowglobes'):
		$snowglobe_house.hide()