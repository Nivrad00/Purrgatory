extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	if not state.get('blackout'):
		$hum.play()
	
	if state.get('placed_snowglobes'):
		$bg2.show()
		$bg.hide()
	else:
		$bg2.hide()
		$bg.show()
