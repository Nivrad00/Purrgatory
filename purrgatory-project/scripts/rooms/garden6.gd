extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	
	$exit_dialog.set_highlight_on_hover(true)
	if state.get('flowers_goto_garden'):
		emit_signal('set_hidden_sprite', [$numa])
		state['flowers_goto_garden'] = false
	
func update_state(state):
	.update_state(state)
	
	if state.get('surprise_audio'):
		state['surprise_audio'] = false
		$surprise.play()
		emit_signal('change_audio', null)
	
	if state.get('_inv_screwdriver'):
		$screwdriver2.hide()
		
	# numa is visible by default
	
	$numa.show()
	
	# numa's intro
	
	if state.get('trample_flag'):
		$numa2.show()
	else:
		$numa2.hide()
		
	if state.get('trample_flag') and not state.get('nearly_trampled_flower'):
		$exit_dialog.show()
		$exit.hide()
	else:
		$exit_dialog.hide()
		$exit.show()
		
	# numa's quest
	
	if state.get('numa_goto_flowerbed'):
		emit_signal('change_room', 'flowerbed')
		state['numa_goto_flowerbed'] = false
		
	if state.get('elijah_show_numa'):
		emit_signal('set_hidden_sprite', [$numa])
		state['elijah_show_numa'] = false
	
	if state.get('poetry_session'):
		$numa.hide()
		$garden_flower2.hide()
		$numa_and_elijah_poetry.show()
	else:
		$garden_flower2.show()
		$numa_and_elijah_poetry.hide()
	
	if state.get('elijah_working_with_numa_timer'):
		state['elijah_working_with_numa_timer'] = false
		state['poetry_session'] = true
		emit_signal('start_action_timer', 20, ['poetry_session', false])
		
	if state.get('numa_goto_commons'):
		emit_signal('change_room', 'hallway1')
		state['numa_goto_commons'] = false
		
	if state.get('numa_crying') or state.get('numa_quest_complete'):
		$numa.hide()
	
func end_poetry_session(state):
	state['poetry_session'] = false
	