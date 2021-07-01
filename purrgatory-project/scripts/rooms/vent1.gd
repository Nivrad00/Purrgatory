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
	
	$vent_not_rn.hide()
	# override this if you're doing the poem search and you haven't snooped yet
	if state.get('looking_for_poem') and not state.get('numa_snooped'):
		$vent_not_rn.show()
		$vent_open.hide()
		$vent_closed.hide()
		