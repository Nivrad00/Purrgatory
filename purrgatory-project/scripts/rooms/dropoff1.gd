extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	state['saw_dropoff'] = true
	
func update_state(state):
	.update_state(state)
	
	if state.get('sean_looking_for_elijah') and not state.get('elijah_quest_complete'):
		$elijah_dropoff.show()
	else:
		$elijah_dropoff.hide()
	
	if state.get('oliver_goto_ttt'):
		state['oliver_goto_ttt'] = false
		emit_signal('change_room', 'ttt')
	
	if state.get('oliver_sleeping_timer'):
		state['oliver_sleeping_timer'] = false
		emit_signal('start_action_timer', 50, ['oliver_sleeping', false])
		emit_signal('start_action_timer', 50, ['oliver_in_study', false])
	
	if state.get('tori_closet_complete') and not state.get('tori_dropoff_complete'):
		$tori_dropoff.show()
	else:
		$tori_dropoff.hide()
	
	if state.get('preparing_for_climb') and not state.get('tori_dropoff_complete'):
		$exit.hide()
		$cant_leave.show()
		$cant_leave.set_highlight_on_hover(true)
	else:
		$cant_leave.hide()
		$exit.show()
	
	if state.get('tori_dropoff_complete'):
		$dropoff_again.show()
		$dropoff_again.set_highlight_on_hover(true)
		$dropoff_dropoff.hide()
	else:
		$dropoff_again.hide()
		$dropoff_dropoff.show()
	
	$bg.hide()
	$bg1.hide()
	$bg2.hide()
	
	if state.get('tori_dropoff_complete'):
		$bg2.show()
	elif state.get('preparing_for_climb'):
		$bg1.show()
	else:
		$bg.show()
	
	if state.get('toss_coin'):
		$coin/AnimationPlayer.play('paraola')
		state['toss_coin'] = false