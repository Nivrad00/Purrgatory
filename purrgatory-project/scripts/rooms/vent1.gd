extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	
func update_state(state):
	.update_state(state)
	
	if state.get('opened_vent') and !state.get('numa_snooped'):
		$vent_open.show()
		$vent_closed.hide()
	else:
		$vent_open.hide()
		$vent_closed.show()
