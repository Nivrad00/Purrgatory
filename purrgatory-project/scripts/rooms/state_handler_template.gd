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

# note: if a state handler script has an options_changed() method, it will be
#   called whenever an option changes

export var default_music = 'welcome to purrgatory'

func play_default_music():
	if default_music != '_pass':
		emit_signal('change_audio', default_music)

func init_state(state):
	pass
	
func update_state(state):
	for key in state.keys():
		if key.substr(0, 7) == '_music_' and state[key]:
			print('b')
			state[key] = false
			var music = key.substr(7, len(key)-7)
			if music == 'null':
				print('c')
				emit_signal('change_audio', null)
			else:
				print(music)
				emit_signal('change_audio', music)
		
	for child in get_children():
		var key = '_inv_' + child.name
		if state.get(key):
			child.hide()