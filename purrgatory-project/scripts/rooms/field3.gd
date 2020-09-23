extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	
	var r = rand_range(0, 100)
	if state.get('met_sean') and floor(r) == 0:
		$sean_fence.show()
	else:
		$sean_fence.hide()
		
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
		$digging/score.text = str(state['hole_count']) + '/16'
				
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
		
func play_default_music(state):
	if default_music != '_pass':
		if state.get('park_game'):
			emit_signal('change_audio', 'somewhere between draft')
		else:
			emit_signal('change_audio', default_music)