extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	if state.get('sean_went_to_piano') and \
	  (not state.get('sean_looking_for_elijah') or state.get('sean_quest_complete')):
		$sean_piano.show()
	else:
		$sean_piano.hide()