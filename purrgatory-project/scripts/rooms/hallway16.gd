extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	if not state.get('blackout'):
		$hum.play()