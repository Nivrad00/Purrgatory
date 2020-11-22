extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	if not state.get('blackout') and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play('New Anim')
		