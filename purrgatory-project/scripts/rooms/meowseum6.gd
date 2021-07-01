extends 'state_handler_template.gd'
	
func init_state(state):
	.init_state(state)
	
	if state.get('ks_and_numa_meowseum_done'):
		state['ks_and_numa_at_meowseum'] = false
		
func update_state(state):
	.update_state(state)
	
	if state.get('_inv_draw_a_paw') or state.get('returned_draw_a_paw'):
		$draw_a_paw.hide()
		
	if state.get('ks_and_numa_at_meowseum'):
		$ks_and_numa.show()
	else:
		$ks_and_numa.hide()
		
	if state.get('display_kyungsoon_and_numa'):
		state['display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [$ks_and_numa])
		
	if state.get('dont_display_kyungsoon_and_numa'):
		state['dont_display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [])
