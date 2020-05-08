extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	if state.get('sean_went_to_piano') and \
	  (not state.get('sean_looking_for_elijah') or state.get('elijah_sean_left_bench')):
		$sean_piano.show()
	else:
		$sean_piano.hide()
	
	if state.get('sean_arguing_with_tori'):
		$sean_piano.hide()
		$sean_arguing_with_tori.show()
	else:
		$sean_arguing_with_tori.hide()
	
func init_state(state):
	.init_state(state)
	
	if state.get('sean_arguing_with_tori'):
		state['sean_arguing_with_tori'] = false
		
	if state.get('custom_goto_piano2'):
		state['custom_goto_piano2'] = false
		emit_signal('set_hidden_sprite', [$sean_piano])