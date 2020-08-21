extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
		
func update_state(state):
	.update_state(state)
	
	for button in $digging.get_children():
		if button is Area2D:
			var label = button.dialog_label
			if state.get('_dug_' + label.substr(10, label.length()-1)):
				button.dug_hole()
	
	if state.get('park_game'):
		$digging/score.text = str(state['hole_count']) + '/16'
				
	if state.get('oliver_goto_ttt'):
		state['oliver_goto_ttt'] = false
		emit_signal('change_room', 'ttt')
		
	if state.get('oliver_sleeping_timer'):
		state['oliver_sleeping_timer'] = false
		emit_signal('start_action_timer', 50, ['oliver_sleeping', false])
		emit_signal('start_action_timer', 50, ['oliver_in_study', false])
	
	if state.get('elijah_quest_complete') and not state.get('elijah_sean_left_bench'):
		$elijah_and_sean_bench.show()
	else:
		$elijah_and_sean_bench.hide()
		
	if state.get('tori_park_complete'):
		$digging.show()
		$digging/score.hide()
	elif state.get('park_game'):
		$digging.show()
		$digging/score.show()
	else:
		$digging.hide()
		$digging/score.hide()
		
	if state.get('park_game') or state.get('_dug_snowglobe'):
		$x.hide()
	else:
		$x.show()
		
	if state.get('surprise_audio'):
		print('!')
		state['surprise_audio'] = false
		$surprise.play()
		emit_signal('change_audio', null)
	
	if state.get('increment_holes'):
		state['increment_holes'] = false
		if not state.get('hole_count'):
			state['hole_count'] = 0
		state['hole_count'] += 1
		$digging/score.text = str(state['hole_count']) + '/16'
		
func play_default_music(state):
	if default_music != '_pass':
		if state.get('park_game'):
			emit_signal('change_audio', 'somewhere between draft')
		else:
			emit_signal('change_audio', default_music)