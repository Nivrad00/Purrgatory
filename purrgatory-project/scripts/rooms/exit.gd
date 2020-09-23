extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	$tori_exit1.hide()
	$tori_exit2.hide()
	
	if state.get('tori_dropoff_complete') and not (state.get('tori_quest_complete') or state.get('queue_tori_flashback')):
		$tori_exit1.show()
	elif state.get('tori_quest_complete') or state.get('queue_tori_flashback'):
		$tori_exit2.show()
	
	$exit.hide()
	$exit2.hide()
	
	if state.get('queue_tori_flashback'):
		$exit2.show()
	else:
		$exit.show()
	
	if state.get('stop_kicking_sounds'):
		state['stop_kicking_sounds'] = false
		$thud.stop()
		
	if state.get('start_kicking_sounds'):
		state['start_kicking_sounds'] = false
		$thud.play()