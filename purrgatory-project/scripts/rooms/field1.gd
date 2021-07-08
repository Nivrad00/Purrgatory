extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('elijah_why'):
		state['elijah_why'] = false
			
func update_state(state):
	.update_state(state)
	
	# oliver's stuff 
	
	if state.get('oliver_goto_park2'):
		state['oliver_goto_park2'] = false
		emit_signal('change_room', 'field2')
	
	# elijah's stuff
	
	if state.get('elijah_quest_complete'):
		$elijah_field.show()
		$sean_field.show()
		$weeds.show()
		$wheelbarrow.show()
	else:
		$elijah_field.hide()
		$sean_field.hide()
		$weeds.hide()
		$wheelbarrow.hide()
	
	# elijah should disappear if:
	# * elijah ran after numa to get a water bottle
	# * elijah's helping numa with her poem
	# * you're with oliver right now
	if state.get('elijah_why') or state.get('poetry_session') or state.get('oliver_on_date'):
		$elijah_field.hide()
		
	# sean should disappear if you're with oliver right now
	if state.get('oliver_on_date'):
		$sean_field.hide()
		
	# helper states so that we can control sprites both here and in hallway8
	
	if state.get('display_elijah_and_sean'):
		emit_signal('set_hidden_sprite', [$elijah_field, $sean_field])
		state['display_elijah_and_sean'] = false
		
	if state.get('display_sean'):
		emit_signal('set_hidden_sprite', [$sean_field])
		state['display_sean'] = false
		
	if state.get('display_elijah'):
		emit_signal('set_hidden_sprite', [$elijah_field])
		state['display_elijah'] = false
		
	# tori's stuff
	
	for button in $digging.get_children():
		if button is Area2D:
			var label = button.dialog_label
			if state.get('_dug_' + label.substr(10, label.length()-10)):
				button.dug_hole()
	
	if state.get('park_game'):
		if not state.get('hole_count'):
			state['hole_count'] = 0
		$digging/score.text = str(state['hole_count']) + '/16'
	
	if state.get('tori_park_complete'):
		$digging.show()
		$digging/score.hide()
		$exit3.show()
		$exit3_game.hide()
	elif state.get('park_game'):
		$digging.show()
		$digging/score.show()
		$exit3.hide()
		$exit3_game.show()
	else:
		$digging.hide()
		$digging/score.hide()
		$exit3.show()
		$exit3_game.hide()
		
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
			emit_signal('change_audio', default_music)
		else:
			emit_signal('change_audio', default_music)
