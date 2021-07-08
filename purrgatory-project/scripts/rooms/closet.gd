extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	if state.get('tori_park_complete') and not state.get('tori_closet_complete'):
		$tori_closet.show()
	else:
		$tori_closet.hide()
		
	if state.get('natalie_completed_mural') and not state.get('natalie_working_on_nocturnal'):
		$tori_closet.hide()
		
	if state.get('tori_park_complete'):
		$closet_open_box.show()
		$electric_box_warning.hide()
		$electric_box_note.hide()
	else:
		$closet_open_box.hide()
		$electric_box_warning.show()
		$electric_box_note.show()
	
	if state.get('queue_hide_tori'):
		state['queue_hide_tori'] = false
		emit_signal('change_audio', null)
		emit_signal('set_hidden_sprite', [$tori_closet])
	
	if state.get('_inv_snowglobe_closet') or state.get('spent_snowglobes'):
		$snowglobe_closet.hide()
		
	if state.get('sean_replaced_batteries') or state.get('_inv_battery1'):
		$battery1.hide()
