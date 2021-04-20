extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
		
	if state.get('gave_cat_toy'):
		$cat_toy.show()
	else:
		$cat_toy.hide()
