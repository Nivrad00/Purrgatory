extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
			
	if get_value('opened_vent', state) and !get_value('numa_snooped', state):
		$vent_open.show()
		$vent_closed.hide()
	else:
		$vent_open.hide()
		$vent_closed.show()
		
	if get_value('ks_at_vent', state):
		$kyungsoon_at_vent.show()
	else:
		$kyungsoon_at_vent.hide()
		
	if get_value('ks_at_vent_timer', state):
		state['ks_at_vent_timer'] = false
		state['ks_at_vent'] = true
		emit_signal('start_action_timer', 20, ['ks_at_vent', false])
		emit_signal('start_action_timer', 20, ['numa_at_commons', true])