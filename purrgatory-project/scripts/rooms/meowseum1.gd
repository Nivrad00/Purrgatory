extends 'state_handler_template.gd'

func _ready():
	$exit_dialog.highlight_on_hover = true
	
func update_state(state):
	.update_state(state)
	if state.get('oliver_goto_ttt'):
		state['oliver_goto_ttt'] = false
		emit_signal('change_room', 'ttt')
		
	if state.get('oliver_sleeping_timer'):
		state['oliver_queue_silence'] = false
		state['oliver_sleeping_timer'] = false
		emit_signal('start_action_timer', 40, ['oliver_sleeping', false])
		emit_signal('start_action_timer', 40, ['oliver_in_study', false])
		emit_signal('start_action_timer', 40, ['oliver_woke_up', true])
	
	if state.get('oliver_queue_silence'):
		state['oliver_queue_silence'] = false
		emit_signal('change_audio', null)
	
	if state.get('played_ttt') and state.get('oliver_chose_meowseum'):
		$ttt.show()
	else:
		$ttt.hide()
		
	# elijah and sean stuff
	
	$exit.hide()
	$exit_dialog.hide()
	if state.get('sean_broke_sculpture') and not state.get('sean_went_to_piano'):
		$exit_dialog.show()
	else:
		$exit.show()
