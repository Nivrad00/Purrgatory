extends 'state_handler_template.gd'

func _ready():
	$exit3.set_highlight_on_hover(false)

func update_state(state):
	.update_state(state)
	
	$sean_piano.hide()
	if state.get('sean_went_to_piano') and not state.get('sean_on_walk') and not state.get('did_slam'):
		$sean_piano.show()
	else:
		$exit3.show()
	
	$sean_arguing_with_tori.hide()
	if state.get('sean_arguing_with_tori'):
		$sean_piano.hide()
		$exit3.hide()
		$sean_arguing_with_tori.show()
	
	if state.get('play_chord'):
		state['play_chord'] = false
		$chord.play()
		
	if state.get('play_mary_had_a_little_lamb'):
		state['play_mary_had_a_little_lamb'] = false
		emit_signal('change_audio', '')
		$mary_had_a_little_lamb.play()
	
	if state.get('end_mary'):
		state['end_mary'] = false
		emit_signal('change_audio', default_music)
	
	if state.get('play_snippet1'):
		state['play_snippet1'] = false
		$snippet1.play()
		
	if state.get('play_snippet2'):
		state['play_snippet2'] = false
		$snippet2.play()
		
	if state.get('play_snippet3'):
		state['play_snippet3'] = false
		$snippet3.play()
	
	$piano.show()
	$exit2.show()
	$exit2_copy.hide()
	# if the piano's at the slam
	if state.get('slam_in_session'):
		$exit3.hide()
		$piano.hide()
		# also need to adjust the back exit hitbox
		$exit2.hide()
		$exit2_copy.show()
		
func init_state(state):
	.init_state(state)
	
	if state.get('sean_arguing_with_tori'):
		state['sean_arguing_with_tori'] = false
		
	if state.get('sean_on_walk'):
		state['sean_on_walk'] = false	
		
	if state.get('custom_goto_piano2'):
		state['custom_goto_piano2'] = false
		emit_signal('set_hidden_sprite', [$sean_piano])
