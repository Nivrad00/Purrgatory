extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if get_value('numa_snooped', state):
		emit_signal('start_dialog', 'snoop', null)
	
func update_state(state):
	.update_state(state)
	if get_value('snoop_leave_vent', state):
		emit_signal('change_room', 'hallway6')
		state['snoop_leave_vent'] = false