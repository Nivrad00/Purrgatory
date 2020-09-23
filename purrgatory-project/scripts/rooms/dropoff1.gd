extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	state['saw_dropoff'] = true
	
func update_state(state):
	.update_state(state)
	
	# default state
	
	$tori_dropoff.hide()
	$tori_dropoff2.hide()
	$elijah_dropoff.hide()
	$dropoff_rope.hide()
	$dropoff_rope2.hide()
	$cant_leave.hide()
	$exit.show()
	$dropoff_again.hide()
	$dropoff_dropoff.show()
	$bg.show()
	$bg1.hide()
	$bg2.hide()
	
	# oliver's stuff, which supercedes elijah and tori's
	
	if state.get('oliver_goto_ttt'):
		state['oliver_goto_ttt'] = false
		emit_signal('change_room', 'ttt')
	
	if state.get('oliver_sleeping_timer'):
		state['oliver_sleeping_timer'] = false
		emit_signal('start_action_timer', 40, ['oliver_sleeping', false])
		emit_signal('start_action_timer', 40, ['oliver_in_study', false])
	
	if state.get('oliver_override_dropoff'):
		return
	
	# elijah's stuff, which supercedes tori's
		
	if state.get('sean_looking_for_elijah') and not state.get('elijah_quest_complete'):
		$elijah_dropoff.show()
		return
	
	# tori's stuff
	
	if state.get('tori_closet_complete') and not state.get('preparing_for_climb'):
		$tori_dropoff.show()
	elif state.get('preparing_for_climb') and not state.get('tori_dropoff_complete'):
		$tori_dropoff2.show()
	
	if (state.get('tori_closet_complete') and not state.get('preparing_for_climb'))\
	or state.get('tori_dropoff_complete'):
		$dropoff_rope.show()
	
	if state.get('preparing_for_climb') and not state.get('tori_dropoff_complete'):
		$cant_leave.show()
		$exit.hide()
		$cant_leave.set_highlight_on_hover(true)
	
	if state.get('tori_dropoff_complete'):
		$dropoff_again.show()
		$dropoff_again.set_highlight_on_hover(true)
		$dropoff_dropoff.hide()
	
	if state.get('tori_dropoff_complete'):
		$bg2.show()
	elif state.get('preparing_for_climb'):
		$bg1.show()
		$dropoff_rope2.show()
	
	if state.get('toss_coin'):
		$coin/AnimationPlayer.play('paraola')
		state['toss_coin'] = false
