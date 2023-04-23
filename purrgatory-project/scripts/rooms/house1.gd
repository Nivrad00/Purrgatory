extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	
	if state.get('ks_and_numa_house_done'):
		state['ks_and_numa_at_house'] = false
	
func update_state(state):
	.update_state(state)
	
	if state.get('display_kyungsoon_and_numa'):
		state['display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [$ks_and_numa])
		
	if state.get('ks_and_numa_at_house'):
		$ks_and_numa.show()
	else:
		$ks_and_numa.hide()
		
	if state.get('dont_display_kyungsoon_and_numa'):
		state['dont_display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [])

	# need to handle the looking_for_poem spites manually in this scene
	# since elijah's here
	$elijah_searching.hide()
	if state.get('looking_for_poem'):
		$elijah_searching.show()
		$ks_and_numa.hide()
	elif state.get('slam_outro'):
		$ks_and_numa.hide()
		
	
	if state.get('elijah_alert'):
		state['elijah_alert'] = false
		$surprise.play()
		emit_signal('change_audio', '')
		
