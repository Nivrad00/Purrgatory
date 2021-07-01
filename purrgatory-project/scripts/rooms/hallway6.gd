extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
			
	if state.get('ks_at_vent'):
		$kyungsoon_at_vent.show()
	else:
		$kyungsoon_at_vent.hide()
		
	if state.get('ks_at_vent_timer'):
		state['ks_at_vent_timer'] = false
		state['ks_at_vent'] = true
		state['ks_at_commons'] = false
		emit_signal('start_action_timer', 40, ['ks_at_vent', false])
		emit_signal('start_action_timer', 40, ['ks_at_commons', true])
		emit_signal('start_action_timer', 40, ['numa_at_commons', true])
		
	if state.get('display_kyungsoon_and_numa'):
		state['display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [$kyungsoon_at_vent])