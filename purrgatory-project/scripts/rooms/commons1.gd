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

# modify these functions
func init_state(state):
	if get_value('drama_ongoing', state):
		emit_signal('start_dialog', 'drama_start', $kyungsoon_idle)
	if get_value('oliver_hears_numa', state):
		$oliver_huh.show()
		state['oliver_hears_numa'] = false
	else:
		$oliver_huh.hide()
	if get_value('commons_flowers', state):
		$flowers_etc.show()
	else:
		$flowers_etc.hide()
	
func update_state(state):
	if get_value('ks_goto_vents', state):
		emit_signal('change_room', 'hallway6')