extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('elijah_why'):
		state['elijah_why'] = false
		
func update_state(state):
	.update_state(state)
	if state.get('oliver_goto_park2'):
		state['oliver_goto_park2'] = false
		emit_signal('change_room', 'field2')
	
	if state.get('elijah_sean_left_bench'):
		$elijah_park.show()
		$weeds.show()
		$wheelbarrow.show()
	else:
		$elijah_park.hide()
		$weeds.hide()
		$wheelbarrow.hide()
	
	if state.get('elijah_why'):
		$elijah_park.hide()