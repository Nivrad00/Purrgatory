extends 'state_handler_template.gd'

var state = null
var out_of_batteries = false


func return_to_dialog(label):
	emit_signal('start_dialog', label, [])
	
func update_state(s):
	.update_state(s)
	
	if state.get('custom_goto_piano2'):
		emit_signal('change_room', 'piano2')
	
	if state.get('disable_exit'):
		state['disable_exit'] = false
		$exit4.hide()
	else:
		$exit4.show()
		
	for key in state.keys():
		if key.substr(0, 7) == '_piano_' and state[key]:
			state[key] = false
		
			var song = key.substr(7, len(key)-7)
			$sean_player.load_song(song)
			$sean_player.start_song()
		
	
func init_state(s):
	.init_state(s)
	state = s
	
	# load the piano options
	if not 'piano_power' in state:
		state['piano_power'] = false
	$options/power.pressed = state['piano_power']
	update_mute($options/power.pressed)
	
	if not 'piano_volume' in state:
		state['piano_volume'] = 270
	$options/volume.rect_rotation = state['piano_volume']
	update_volume($options/volume.rect_rotation)
	
	if state.get('sean_out_of_batteries') and not state.get('sean_replaced_batteries'):
		out_of_batteries = true
		AudioServer.set_bus_mute(AudioServer.get_bus_index('Keyboard'), true)
		emit_signal('start_dialog', 'out_of_batteries')

func update_volume(volume):
	state['piano_volume'] = volume
	var db = math(volume/360)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Keyboard'), db)

func update_mute(on):
	state['piano_power'] = on
	if not out_of_batteries:
		AudioServer.set_bus_mute(AudioServer.get_bus_index('Keyboard'), !on)
		
func math(value):
	if value == 0:
		return -80
	return 27 * log(value)/log(10)