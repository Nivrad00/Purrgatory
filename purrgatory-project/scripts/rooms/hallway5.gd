extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	
	# if you just got done with oliver's date, you can clear the override thing now
	if state.get('oliver_override_dropoff'):
		state['oliver_override_dropoff'] = false
	
func update_state(state):
	.update_state(state)
	if state.get('oliver_goto_dropoff3'):
		state['oliver_goto_dropoff3'] = false
		emit_signal('change_room', 'dropoff1')
		
	# you actually can't go to the dropoff with oliver anymore
	# so this is the only actually useful part of this script lol
	if state.get('tori_closet_complete') and not state.get('preparing_for_climb')\
	and not state.get('looking_for_poem'):
		$bg_alt.show()
		$bg.hide()
	else:
		$bg_alt.hide()
		$bg.show()
