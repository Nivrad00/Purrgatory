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

export var default_music = 'welcome to purrgatory'

func play_default_music():
	emit_signal('change_audio', default_music)

func init_state(state):
	pass
	
func update_state(state):
	for child in get_children():
		var key = '_inv_' + child.name
		if state.get(key):
			child.hide()