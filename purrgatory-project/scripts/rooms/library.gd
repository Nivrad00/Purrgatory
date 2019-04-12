extends Control

# each room should have a separate state-handling script
# (unless that room has no state, in which case you can use state_handler_template.gd)
# it updates the room state based on the game state (for example, making doors accessible once they've been unlocked)

func get_value(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false

func init_state(state):
	if get_value('oliver_why', state):
		state['oliver_why'] = false
	
func update_state(state):
	if get_value('met_oliver', state):
		for child in get_children():
			if 'dialog_label' in child and child.dialog_label == 'read_book':
				child.show()
	else:
		for child in get_children():
			if 'dialog_label' in child and child.dialog_label == 'read_book':
				child.hide()
	
	if get_value('oliver_why', state):
		$oliver_idle.hide()
	else:
		$oliver_idle.show()
		