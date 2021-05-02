extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if state.get('broke_vending_machine'):
		$crowbar.hide()
	else:
		$crowbar.show()
		
	if state.get('placed_ladder'):
		$ladder.show()
	else:
		$ladder.hide()
	
	if state.get('took_cat_toy'):
		$cat_toy.hide()
	else:
		$cat_toy.show()
