extends Control

signal start_dialog(label)
signal change_room(label)

# each room should have a separate state-handling script
# (unless that room has no state, in which case you can use state_handler_template.gd)
# it updates the room state based on the game state (for example, making doors accessible once they've been unlocked)

func get_value(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false

# modify these functions
func init_state(state):
	pass
	
func update_state(state):
	if get_value('unlocked_commons_door', state):
		$commons_door_exit.show()
		$commons_door_dialog.hide()
	else:
		$commons_door_exit.hide()
		$commons_door_dialog.show()