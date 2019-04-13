extends Control

signal start_dialog(label)

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
	if get_value('drama_ongoing', state):
		emit_signal('start_dialog', 'drama_start', $kyungsoon_idle)
	
func update_state(state):
	pass