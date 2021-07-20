extends 'state_handler_template.gd'

func play_default_music(state):
	if state.get('purrgatory_blues_loop'):
		emit_signal('change_audio', 'purrgatory_blues_loop')
	else:
		emit_signal('change_audio', default_music)
	
func update_state(state):
	.update_state(state)
	
	if state.get('button_sound'):
		state['button_sound'] = false
		$button.play()
	
	$slam_elijah.hide()
	$slam_natalie.hide()
	$slam_sean.hide()
	$slam_tori.hide()
	$slam_sean_shh.hide()
	$slam_oliver_shh.hide()
	$slam_natalie_shh.hide()
	$slam_numa_shh.hide()
	$slam_tori_shh.hide()
	$slam_oliver_after.hide()
	
	if state.get('post_slam'): # slam is over, people are cleaning up or left already
		$slam_oliver_after.show()
	elif state.get('slam_outro'): # elijah reads poem, wraps up slam
		$slam_oliver_shh.show()
		$slam_natalie_shh.show()
		$slam_numa_shh.show()
		$slam_tori_shh.show()
	elif state.get('looking_for_poem'): # you look-a for da poem
		$slam_sean_shh.show()
		$slam_oliver_shh.show()
		$slam_natalie_shh.show()
		$slam_numa_shh.show()
		$slam_tori_shh.show()
	elif state.get('slam_intro'): # elijah introduces the slam, sean sings
		$slam_oliver_shh.show()
		$slam_natalie_shh.show()
		$slam_numa_shh.show()
		$slam_tori_shh.show()
	else: # everyone is preparing for the slam
		$slam_elijah.show()
		$slam_natalie.show()
		$slam_sean.show()
		$slam_tori.show()

	$slam_planks.hide()
	$slam_planks2.hide()
	
	if state.get('post_slam') or state.get('slam_outro'):
		$slam_planks2.show()
	else:
		$slam_planks.show()
	
	for i in range(16):
		if state.get('purrgatory_blues' + str(i)):
			if i == 0:
				$blues.play()
			else:
				state['purrgatory_blues' + str(i-1)] = false
				$blues.play(99.30/16 * i)
			$blues_timer.start()
			
	if state.get('purrgatory_blues_loop'):
		emit_signal('change_audio', 'purrgatory_blues_loop')
		state['purrgatory_blues15'] = false
		$blues.stop()
		$blues_timer.stop()

func _on_blues_timer_timeout():
	get_node('../../../../..').update_dialog(-1)
