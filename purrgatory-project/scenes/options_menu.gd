extends Control

signal options_changed()
signal toggle_notes(on)

var quips = [
	['cat', 'meow meow, meow meow meow :3'],
	['oliver', 'to meow, or not to meow, that is the question!'],
	['kyungsoon', 'hmmm. that\'s an options menu'],
	['numa', 'HEY!! change the font size right now! i mean... if you want.'],
	['sean', 'what\'s a nice player like you doing in a menu like this? (;'],
	['elijah', '\'tis better to have meowed and lost than never to have meowed at all.']
]

var default_options = {
	"fullscreen": false,
	"music_volume": 1,
	"sfx_volume": 1,
	"text_size": 24
}

func save_options():
	# saves options to file
	# (the options are applied as soon as the values are changed or the game starts, so no need to apply anything here)
	# this method is called when the options menu closes, and when the game closes
	
	var options_dict = {
		"fullscreen": $fullscreen/fullscreen.pressed,
		"music_volume": $audio/music.value,
		"sfx_volume": $audio/sfx.value,
		"text_size": $text_size/slider.value,
		"notes_enabled": $enable_notes/enable_notes.pressed
	}
	var options_save = File.new()
	options_save.open("res://save_data/options.save", File.WRITE)
	options_save.store_line(to_json(options_dict))
	options_save.close()
		
	emit_signal('options_changed')

func load_options():
	# loads options from file whenever the options menu is opened (and when the game starts)
	# ensures options are consistent between sessions and between the main and pause menus
	# (the options are applied as soon as the values are changed or the game starts, so no need to apply anything here)
	
	var options_save = File.new()
	var options_dict = default_options
	
	if options_save.file_exists("res://save_data/options.save"):
		options_save.open("res://save_data/options.save", File.READ)
		options_dict = parse_json(options_save.get_line())
		options_save.close()
		
	$fullscreen/fullscreen.pressed = options_dict['fullscreen']
	$audio/music.value = options_dict['music_volume']
	$audio/sfx.value = options_dict['sfx_volume']
	$text_size/slider.value = options_dict['text_size']
	$enable_notes/enable_notes.pressed = options_dict['notes_enabled']
	
	# also, connect the "enabled_notes" option to the notes menu if not done already
	# and this absolute path is disgusting but find_node isn't working so whatever
	if get_signal_connection_list('toggle_notes').size() == 0:
		var dropdown = get_node('/root/main/game/meta_ui/dropdown')
		if dropdown == null:
			print('hey boss, the options menu can\'t find the dropdown menu to connect enabled_notes')
		else:
			connect('toggle_notes', dropdown, 'toggle_quest_log')
	
	return options_dict

func load_and_apply_options():
	# this is only called when the game starts
	var options_dict = load_options()
	_on_music_value_changed(options_dict['music_volume'])
	_on_sfx_value_changed(options_dict['sfx_volume'])
	_on_fullscreen_toggled(options_dict['fullscreen'])
	_on_text_size_value_changed(options_dict['text_size'])
	_on_enable_notes_toggled(options_dict['notes_enabled'])

func show_custom():
	var state = get_node('/root/main/game').state
	
	var available_quips = [quips[0]]
	for quip in quips:
		if state.get('met_' + quip[0]):
			available_quips.append(quip)
			
	var current_quip = available_quips[randi() % available_quips.size()]
	$text_size/preview_a.set_text(current_quip[0])
	$text_size/preview_b.set_bbcode(current_quip[1])
	
	load_options()
	show()

func change_volume(bus, volume):
	var db = math(volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), db)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), db == -80)
	
func math(value):
	if value == 0:
		return -80
	return 27 * log(value)/log(10)

# below are functions that apply changes to the options

func _on_music_value_changed(value):
	change_volume('Music', value)

func _on_sfx_value_changed(value):
	change_volume('SFX', value)
	
func _on_fullscreen_toggled(on):
	OS.window_fullscreen = on
	
func _on_text_size_value_changed(value):
	$text_size/preview_b.get_font('normal_font').set_size(value)
	$text_size/preview_b.get_font('italics_font').set_size(value)
	var bb = $text_size/preview_b.get_bbcode()
	$text_size/preview_b.clear()
	$text_size/preview_b.set_bbcode(bb)

func _on_enable_notes_toggled(button_pressed):
	emit_signal('toggle_notes', button_pressed)
		
