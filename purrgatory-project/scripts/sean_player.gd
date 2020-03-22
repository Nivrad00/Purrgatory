extends Node2D

var song1 = '0.15|r16' +\
'vee^e2vb3a#2a2g2ega' +\
'dd^e2vb3a#2a2g2ega' +\
'c#c#^e2vb3a#2a2g2ega' +\
'cc^e2vb3a#1d1a2g2ega'

var current_song = []
var current_key = null
var note_length_remaining = 0

func _ready():
	load_song(song1)
	start_song()
	
func start_song():
	$song_timer.start()
	
func stop_song():
	$song_timer.stop()

func load_song(s):
	var a = s.split('|')
	$song_timer.wait_time = float(a[0])
	s = a[1]
	
	var note_list = []
	var note_dict = null
	var octave = 3
	
	for c in s:
		if c in 'abcdefgr':
			if note_dict:
				note_list.append(note_dict)
			note_dict = {
				'pitch': c,
				'accidental': '',
				'octave': str(octave),
				'length': '1'
			}
			
		elif c in '12345678910':
			note_dict['length'] = c
		
		elif c == '#':
			note_dict['accidental'] = '#'
			
		elif c == '^':
			octave += 1
		
		elif c == 'v':
			octave -= 1
	
	if note_dict:
		note_list.append(note_dict)
	
	current_song = note_list
	current_key = null
	note_length_remaining = 0

func play_note():
	note_length_remaining -= 1
	if note_length_remaining > 0:
		return
	
	if current_key:
		current_key.on_key_up()
	
	if current_song.size() == 0:
		stop_song()
		return
		
	$delay_timer.start()
	yield($delay_timer, 'timeout')
	
	var note_dict = current_song.pop_front()
	var note_name = note_dict['pitch'] + note_dict['accidental'] + note_dict['octave']
	note_length_remaining = int(note_dict['length'])
	
	if note_dict['pitch'] != 'r':
		current_key = get_key(note_name)
		current_key.on_key_down()
		current_key.play_note()
		$seans_hand.position = current_key.position 
	else:
		current_key = null
	
	
func get_key(a):
	if '#' in a:
		return get_node('../keyboard_handler2/' + a)
	else:
		return get_node('../keyboard_handler/' + a)
