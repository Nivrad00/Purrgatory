extends 'state_handler_template.gd'
	
func play_default_music(state):
	if state.get('postgame'):
		emit_signal('change_audio', '')
	elif state.get('called_lucifur'):
		emit_signal('change_audio', 'The_Interview')
	else:			
		emit_signal('change_audio', default_music)
		
func update_state(state):
	.update_state(state)
	
	$exit2.hide()
	$exit2_end.hide()
	$exit2_slam.hide()
	if state.get('postgame'):
		$exit2_end.show()
	elif state.get('slam_in_session'):
		$exit2_slam.show()
	else:
		$exit2.show()
	
func exit_pressed():
	$white_cover.show()
	$white_cover.get_node('AnimationPlayer').play('Fade In')
	get_node('../../../../..').disable_ui()
	yield($white_cover/AnimationPlayer, 'animation_finished')
	emit_signal('change_room', 'bad_credits')
	
	
