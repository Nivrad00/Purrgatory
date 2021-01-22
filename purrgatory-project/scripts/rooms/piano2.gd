extends 'state_handler_template.gd'

func _ready():
	$exit3.set_highlight_on_hover(false)
	
func update_state(state):
	.update_state(state)
	
	if state.get('sean_went_to_piano') and \
	  (not state.get('sean_looking_for_elijah') or state.get('elijah_sean_left_bench')):
		$sean_piano.show()
		$exit3.hide()
	else:
		$sean_piano.hide()
		$exit3.show()
	
	if state.get('sean_arguing_with_tori'):
		$sean_piano.hide()
		$sean_arguing_with_tori.show()
	else:
		$sean_arguing_with_tori.hide()
	
	if state.get('purrgatory_blues1'):
		state['purrgatory_blues1'] = false
		emit_signal('change_audio', '')
		$purrgatory_blues1.play()
		$purrgatory_blues_timer.start()
		
	if state.get('purrgatory_blues2'):
		state['purrgatory_blues2'] = false
		emit_signal('change_audio', '')
		$purrgatory_blues1.stop()
		$purrgatory_blues2.play()
		$purrgatory_blues_timer.stop()
		$purrgatory_blues_timer.start()
		
	if state.get('purrgatory_blues3'):
		state['purrgatory_blues3'] = false
		emit_signal('change_audio', '')
		$purrgatory_blues2.stop()
		$purrgatory_blues3.play()
		$purrgatory_blues_timer.stop()
		$purrgatory_blues_timer.start()
		
	if state.get('purrgatory_blues4'):
		state['purrgatory_blues4'] = false
		emit_signal('change_audio', '')
		$purrgatory_blues3.stop()
		$purrgatory_blues4.play()
		$purrgatory_blues_timer.stop()
		
	if state.get('end_purrgatory_blues'):
		state['end_purrgatory_blues'] = false
		emit_signal('change_audio', default_music)
		$purrgatory_blues4.stop()
		
	if state.get('play_corner_store_music1'):
		state['play_corner_store_music1'] = false
		$dont_meowget_me1.play()
		
	if state.get('play_corner_store_music2'):
		state['play_corner_store_music2'] = false
		$dont_meowget_me2.play()
		
	if state.get('play_corner_store_music3'):
		state['play_corner_store_music3'] = false
		emit_signal('change_audio', '')
		$dont_meowget_me3.play()
		
	if state.get('end_corner_store_music'):
		state['end_corner_store_music'] = false
		$dont_meowget_me1.stop()
		$dont_meowget_me2.stop()
		$dont_meowget_me3.stop()
	
func init_state(state):
	.init_state(state)
	
	if state.get('sean_arguing_with_tori'):
		state['sean_arguing_with_tori'] = false
		
	if state.get('custom_goto_piano2'):
		state['custom_goto_piano2'] = false
		emit_signal('set_hidden_sprite', [$sean_piano])

func _on_purrgatory_blues_timer_timeout():
	get_node('../../../../..').update_dialog(-1)
