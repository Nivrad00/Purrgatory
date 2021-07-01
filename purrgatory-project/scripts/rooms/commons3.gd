extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	$exit.hide()
	$exit_slam.hide()
	if state.get('slam_in_session'):
		$exit_slam.show()
	else:
		$exit.show()