extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	
	if state.get('ks_and_numa_house_done'):
		state['ks_and_numa_at_house'] = false
	
func update_state(state):
	.update_state(state)
	
	if state.get('ks_and_numa_at_house'):
		$ks_and_numa.show()
	else:
		$ks_and_numa.hide()
		
	if state.get('dont_display_kyungsoon_and_numa'):
		state['dont_display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [])
