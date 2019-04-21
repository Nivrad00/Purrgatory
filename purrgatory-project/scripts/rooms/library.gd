extends Control

signal start_dialog(label, sprite)
signal change_room(label)

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
	if get_value('oliver_why', state) or get_value('drama_ongoing', state):
		$oliver_idle.hide()
	else:
		$oliver_idle.show()
		