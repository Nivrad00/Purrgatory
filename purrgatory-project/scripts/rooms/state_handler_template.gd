extends Control

signal start_dialog(label, sprite)
signal change_room(label)
signal set_hidden_sprite(sprite)
signal start_action_timer(actions, callback)
signal change_audio(song)

# each room should contain either this script (for default room behavior) or
#   a script that inherits from this scritp
# it updates the room state based on the game state 
#   (for example, making doors accessible once they've been unlocked)

func get_value(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false

func init_state(state):
	pass
	
func update_state(state):
	for child in get_children():
		var key = '_inv_' + child.name
		if get_value(key, state):
			child.hide()