extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	if not state.get('blackout') and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play('New Anim')
	
	if not state.get('blackout'):
		$hum.play()
	
	if state.get('placed_snowglobes'):
		$bg2.show()
		$bg.hide()
		$exit3.show()
	else:
		$bg.show()
		$bg2.hide()
		$exit3.hide()
		
	if state.get('talked_to_kyungsoon_snowglobe') and not state.get('talked_to_kyungsoon_snowglobe_and_left'):
		state['talked_to_kyungsoon_snowglobe_and_left'] = true
