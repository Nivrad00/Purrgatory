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

# another note: "_music" and some other states are handled in here, but "_inv" and
#   "_quest" and some other states are handled in the game node... for some reason.

export var default_music = 'welcome to purrgatory'

func play_default_music():
	if default_music != '_pass':
		emit_signal('change_audio', default_music)

func init_state(state):
	pass
	
func update_state(state):
	for key in state.keys():		
		if key.substr(0, 7) == '_delay_' and state[key]:
			print('DELAY')
			state[key] = false
			state[key.substr(7, len(key)-7)] = true
			
		if key.substr(0, 7) == '_music_' and state[key]:
			print('MUSIC')
			state[key] = false
			var music = key.substr(7, len(key)-7)
			if music == 'null':
				emit_signal('change_audio', null)
			elif music == 'default':
				emit_signal('change_audio', default_music)
			else:
				print(music)
				emit_signal('change_audio', music)
				
		if key.substr(0, 6) == '_goto_' and state[key]:
			state[key] = false
			emit_signal('change_room', key.substr(6, len(key)-6))
		
		
	for child in get_children():
		var key = '_inv_' + child.name
		if state.get(key):
			child.hide()