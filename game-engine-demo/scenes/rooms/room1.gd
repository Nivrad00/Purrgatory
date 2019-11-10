extends Node

# each room should have a separate state-handling script
# it updates the room state based on the game state (for example, making doors accessible once they've been unlocked)

func get_value(key, dict):
	if key in dict:
		return dict[key]
	else:
		dict[key] = false
		return false

# modify this function
func update_state(state):
	if get_value('met_twi_and_qibli', state) or get_value('talking_to_qibli', state):
		$qibli.hide()
	else:
		$qibli.show()
	if get_value('advised_twi', state) or get_value('talking_to_twi', state):
		$twilight.hide()
	else:
		$twilight.show()