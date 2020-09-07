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

func play_default_music(_state):
	if default_music != '_pass':
		emit_signal('change_audio', default_music)

func init_state(state):
	pass

# this is called when the dialog is ending, so it can enact _delay states
func update_state_end(state):
	for key in state.keys():
		if key.substr(0, 14) == '_delay_remove_' and state[key]:
			print('delay remove')
			state[key] = false
			state[key.substr(14, len(key)-14)] = false
		if key.substr(0, 7) == '_delay_' and state[key]:
			print('delay')
			state[key] = false
			state[key.substr(7, len(key)-7)] = true
	
	update_state(state)
	
func update_state(state):
	for key in state.keys():
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
		
		if key.substr(0, 6) == '_hide_' and state[key]:
			var sprite = get_node(key.substr(6, len(key)-6))
			if sprite:
				state[key] = false
				emit_signal('set_hidden_sprite', [sprite])
			else:
				print(key.substr(6, len(key)-6) + ' not found, buffering it for later')
			# useful if you need to set only one hidden sprite
		
		
	for child in get_children():
		var key = '_inv_' + child.name
		if state.get(key):
			child.hide()