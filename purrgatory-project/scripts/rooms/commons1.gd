extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('drama_ongoing'):
		emit_signal('start_dialog', 'drama_start', [$kyungsoon_idle])
	if state.get('oliver_hears_numa'):
		$oliver_huh.show()
		state['oliver_hears_numa'] = false
	else:
		$oliver_huh.hide()
	if state.get('commons_flowers'):
		$flowers_etc.show()
	else:
		$flowers_etc.hide()
		
	if state.get('oliver_goto_commons'):
		state['oliver_goto_commons'] = false
		if state.get('numa_at_commons'):
			emit_signal('set_hidden_sprite', [$kyungsoon_idle, $numa_at_commons])
		else:
			emit_signal('set_hidden_sprite', [$kyungsoon_idle])
	
	if state.get('flashback_goto_commons'):
		state['flashback_goto_commons'] = false
		if state.get('numa_at_commons'):
			emit_signal('set_hidden_sprite', [$kyungsoon_idle, $numa_at_commons])
		else:
			emit_signal('set_hidden_sprite', [$kyungsoon_idle])
	
func update_state(state):
	.update_state(state)
	if state.get('display_kyungsoon_and_numa'):
		state['display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [$kyungsoon_idle, $numa_at_commons])
		
	if state.get('ks_goto_vents'):
		emit_signal('change_room', 'hallway6')
		state['ks_goto_vents'] = false
		
	if state.get('numa_at_commons'):
		$numa_at_commons.show()
		$ending_sign.show()
		$cat1_idle.hide()
	else:
		$numa_at_commons.hide()
		$ending_sign.hide()
		$cat1_idle.show()
		
	if state.get('ks_at_vent'):
		$kyungsoon_idle.hide()
	else:
		$kyungsoon_idle.show()
		
	if state.get('unlocked_commons_door'):
		$commons_door_exit.show()
		$commons_door_dialog.hide()
	else:
		$commons_door_exit.hide()
		$commons_door_dialog.show()