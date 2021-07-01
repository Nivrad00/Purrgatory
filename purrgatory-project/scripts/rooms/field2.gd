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
		if not state.get('hole_count'):
			state['hole_count'] = 0
		$digging/score.text = str(state.get('hole_count')) + '/16'
				
	if state.get('oliver_goto_park3'):
		state['oliver_goto_park3'] = false
		emit_signal('change_room', 'field4')
	
	if state.get('natalie_completed_mural') and not state.get('natalie_working_on_nocturnal'):
		$tori_park.hide()
		$jacket.hide()
	elif state.get('tori_train_complete') and not state.get('tori_park_complete') and not state.get('oliver_on_date'):
		$tori_park.show()
		$jacket.show()
	else:
		$tori_park.hide()
		$jacket.hide()
	
	# quick override during poem search, cus tori's jacket should be in the commons with tori
	# (tori herself gets hidden by the CharacterButton override)
	if state.get('looking_for_poem'):
		$jacket.hide()
	
	if state.get('start_park_game'):
		state['start_park_game'] = false
		state['park_game'] = true
	
	if state.get('tori_park_complete'):
		$digging.show()
		$digging/score.hide()
	elif state.get('park_game'):
		$digging.show()
		$digging/score.show()
	else:
		$digging.hide()
		$digging/score.hide()
		
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
	
	if state.get('tori_train_complete'):
		$dirt.show()
	else:
		$dirt.hide()
		
func play_default_music(state):
	if default_music != '_pass':
		if state.get('park_game'):
			emit_signal('change_audio', default_music)
		else:
			emit_signal('change_audio', default_music)
