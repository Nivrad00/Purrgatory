extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if get_value('drama_ongoing', state):
		emit_signal('start_dialog', 'drama_start', [$kyungsoon_idle])
	if get_value('oliver_hears_numa', state):
		$oliver_huh.show()
		state['oliver_hears_numa'] = false
	else:
		$oliver_huh.hide()
	if get_value('commons_flowers', state):
		$flowers_etc.show()
	else:
		$flowers_etc.hide()
	
func update_state(state):
	.update_state(state)
	if get_value('display_kyungsoon_and_numa', state):
		state['display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [$kyungsoon_idle, $numa_at_commons])
		
	if get_value('ks_goto_vents', state):
		emit_signal('change_room', 'hallway6')
		state['ks_goto_vents'] = false
		
	if get_value('numa_at_commons', state):
		$numa_at_commons.show()
		$ending_sign.show()
		$cat1_idle.hide()
	else:
		$numa_at_commons.hide()
		$ending_sign.hide()
		$cat1_idle.show()
		
	if get_value('ks_at_vent', state):
		$kyungsoon_idle.hide()
	else:
		$kyungsoon_idle.show()