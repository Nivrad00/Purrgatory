extends 'state_handler_template.gd'

var state = null

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

func update_volume(volume):
	state['piano_volume'] = volume
	var db = math(volume/360)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Keyboard'), db)

func update_mute(on):
	state['piano_power'] = on
	AudioServer.set_bus_mute(AudioServer.get_bus_index('Keyboard'), !on)
		
func math(value):
	if value == 0:
		return -80
	return 27 * log(value)/log(10)