extends 'state_handler_template.gd'


func update_state(state):
	.update_state(state)
	
	if state.get('talked_to_kyungsoon_snowglobe_and_left'):
		$kyungsoon_snowglobe.hide()
	else:
		$kyungsoon_snowglobe.show()