extends 'state_handler_template.gd'

var state = null
var alt_power_button = 'res://assets/sprites/keyboard/power_button_on_no_battery.png'

func return_to_dialog(label):
	emit_signal('start_dialog', label, [])

func _ready():
	state = get_node('../../../../..').state
	if state.get('current_piano_song'):
		$sean_player.load_song(state['current_piano_song'])
		$sean_player.start_song()		
	
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
		$options/power.add_icon_override('checked', load(alt_power_button))
	
func update_state(s):
	.update_state(s)
	
	if state.get('custom_goto_piano2'):
		emit_signal('change_room', 'piano2')
	
	if state.get('disable_exit'):
		state['disable_exit'] = false
		$exit4.hide()
		
	if state.get('setup_piano'):
		state['piano_power'] = true
		$options/power.pressed = state['piano_power']
		update_mute($options/power.pressed)
		state['piano_volume'] = 270
		$options/volume.rect_rotation = state['piano_volume']
		update_volume($options/volume.rect_rotation)
		state['setup_piano'] = false
	
	if state.get('_piano_lick-1'):
		$battery_timer.start()
		
	for key in state.keys():
		if key.substr(0, 7) == '_piano_' and state[key]:
			state[key] = false
			state['current_piano_song'] = key.substr(7, len(key)-7)
			$sean_player.load_song(state['current_piano_song'])
			$sean_player.start_song()

func update_volume(volume):
	state['piano_volume'] = volume
	var db = math(volume/360/2)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Keyboard'), db)

func update_mute(on):
	state['piano_power'] = on
		
func math(value):
	if value == 0:
		return -80
	return 27 * log(value)/log(10)

func run_out_of_batteries():
	state['sean_out_of_batteries'] = true
	$options/power.add_icon_override('checked', load(alt_power_button))
