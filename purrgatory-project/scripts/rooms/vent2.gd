extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('numa_snooped'):
		emit_signal('start_dialog', 'snoop', null)
	
func update_state(state):
	.update_state(state)
	if state.get('snoop_leave_vent'):
		emit_signal('change_room', 'hallway6')
		state['snoop_leave_vent'] = false
		
	if state.get('surprise_audio'):
		print('!')
		state['surprise_audio'] = false
		$surprise.play()
		emit_signal('change_audio', null)