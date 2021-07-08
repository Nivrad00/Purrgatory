extends 'state_handler_template.gd'
		
func update_state(state):
	.update_state(state)
	
	if state.get('elijah_quest_complete'):
		$research_poster.show()
	else:
		$research_poster.hide()