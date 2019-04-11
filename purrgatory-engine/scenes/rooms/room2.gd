extends Control

# each room should have a separate state-handling script
# it updates the room state based on the game state (for example, making doors accessible once they've been unlocked)

func get_value(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false

# modify this function
func update_state(state):
	if not get_value('met_twi_and_qibli', state) or get_value('talking_to_qibli', state):
		$qibli.hide()
	else:
		$qibli.show()
	if not get_value('advised_twi', state):
		$twilight.hide()
	else:
		$twilight.show()