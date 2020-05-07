extends Node2D

var current_song = {'left': [], 'right': []}
var current_keys = {'left': [], 'right': []} # contains 2-length arrays [key, length]
var return_label = null

func _ready():
	pass
	
func start_song():
	$song_timer.start()
	
func stop_song():
	$song_timer.stop()
	$left_hand.hide()
	$right_hand.hide()
	for key in current_keys['left'] + current_keys['right']:
		key[0].on_key_up()
	if return_label:
		get_parent().return_to_dialog(return_label)

func load_song(song_name):
	if not $song_timer.is_stopped():
		$song_timer.stop()
		$left_hand.hide()
		$right_hand.hide()
		for key in current_keys['left'] + current_keys['right']:
			key[0].on_key_up()
			
	var song_info = $songs.songs[song_name]
	
	$song_timer.wait_time = song_info['tempo']
	if 'return' in song_info:
		return_label = song_info['return']
	else:
		return_label = null
	
	current_keys = {'left': [], 'right': []}
	
	for hand in ['left', 'right']:
		var note_list = []
		var note_dict = null
		var octave = 3
		
		var chord = null
		for c in song_info[hand]:
			if c in 'abcdefgr':
				note_dict = {
					'pitch': c,
					'accidental': '',
					'octave': str(octave),
					'length': '1'
				}
				if chord != null:
					chord.append(note_dict)
				else:
					note_list.append([note_dict])
				
			elif c in '12345678910':
				note_dict['length'] = c
			
			elif c == '#':
				note_dict['accidental'] = '#'
				
			elif c == '^':
				octave += 1
			
			elif c == 'v':
				octave -= 1
				
			elif c == '[':
				chord = []
				
			elif c == ']':
				note_list.append(chord)
				chord = null
	
		current_song[hand] = note_list

func play_note():
	var hide_hands = []
	var update_hands = []
	
	for hand in ['left', 'right']:
		var done_with_chord = true
		for key_info in current_keys[hand]:
			if key_info[1] > 1:
				key_info[1] -= 1
				done_with_chord = false
			elif key_info[1] == 1:
				key_info[1] -= 1
				if key_info[0]:
					key_info[0].on_key_up()
		
		if done_with_chord:
			current_keys[hand] = []
			if current_song[hand].size() > 0:
				update_hands.append(hand)
		
	if current_song['left'].size() == 0 and current_song['right'].size() == 0 and \
	   current_keys['left'] == [] and current_keys['right'] == []:
		stop_song()
		return
		
	if update_hands.size() > 0:
		$delay_timer.start()
		yield($delay_timer, 'timeout')
		
		for hand in update_hands:
			var chord = current_song[hand].pop_front()
			for note_dict in chord:
				var key_info = [null, null]
				var note_name = note_dict['pitch'] + note_dict['accidental'] + note_dict['octave']
				
				if note_dict['pitch'] != 'r':
					key_info[0] = get_key(note_name)
					key_info[0].on_key_down()
					key_info[0].play_note()
					
					var sprite = get_node(hand + '_hand')
					sprite.show()
					sprite.position = key_info[0].position
					if chord.size() > 1:
						sprite.get_node('claw').show()
						sprite.get_node('finger').hide()
					else:
						sprite.get_node('claw').hide()
						sprite.get_node('finger').show()
						if key_info[0].type == 'black':
							sprite.position.y -= 20
				else:
					key_info[0] = null
					
				key_info[1] = int(note_dict['length'])
				
				current_keys[hand].append(key_info)
	
func get_key(a):
	if '#' in a:
		return get_node('../keyboard_handler2/' + a)
	else:
		return get_node('../keyboard_handler/' + a)
