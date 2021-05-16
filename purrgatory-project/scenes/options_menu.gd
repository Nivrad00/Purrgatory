extends Control

signal options_changed()
signal toggle_notes(on)
signal toggle_voicing(on)
signal hiding()

var resolutions = [
	'854 x 480',
	'1024 x 576',
	'1280 x 720',
	'1600 x 900',
	'1920 x 1080'
]

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
	"music_volume": 0.6,
	"sfx_volume": 0.6,
	"text_size": 24,
	"notes_enabled": true,
	"voicing_enabled": false,
	"resolution": "1280 x 720"
}

func _ready():
	for res in resolutions:
		$window_size/option_button.add_item(res)
		
func save_options():
	# saves options to file
	# (the options are applied as soon as the values are changed or the game starts, so no need to apply anything here)
	# this method is called when the options menu closes
	
	var options_dict = {
		"fullscreen": $fullscreen/fullscreen.pressed,
		"music_volume": $audio/music.value,
		"sfx_volume": $audio/sfx.value,
		"text_size": $text_size/slider.value,
		"notes_enabled": $enable_notes/enable_notes.pressed,
		"voicing_enabled": $voicing/enable_voicing.pressed,
		"resolution": resolutions[$window_size/option_button.selected]
	}
	var options_save = File.new()
	options_save.open("user://options.save", File.WRITE)
	options_save.store_line(to_json(options_dict))
	options_save.close()
		
	emit_signal('options_changed')

func load_options():
	# loads options from file whenever the options menu is opened (and when the game starts)
	# ensures options are consistent between sessions and between the main and pause menus
	# (the options are applied as soon as the values are changed or the game starts, so no need to apply anything here)
	
	var options_save = File.new()
	var options_dict = default_options
	
	if options_save.file_exists("user://options.save"):
		options_save.open("user://options.save", File.READ)
		options_dict = parse_json(options_save.get_line())
		options_save.close()
		
	$fullscreen/fullscreen.pressed = options_dict['fullscreen']
	$audio/music.value = options_dict['music_volume']
	$audio/sfx.value = options_dict['sfx_volume']
	$text_size/slider.value = options_dict['text_size']
	$enable_notes/enable_notes.pressed = options_dict['notes_enabled']
	$voicing/enable_voicing.pressed = options_dict['voicing_enabled']
	$window_size/option_button.selected = resolutions.find(options_dict['resolution'])
	
	# also, connect the "enabled_notes" and "enabled_tts" option to the notes menu if not done already
	# and this absolute path is disgusting but find_node isn't working so whatever
	if get_signal_connection_list('toggle_notes').size() == 0:
		var dropdown = get_node('/root/main/game/meta_ui/dropdown')
		if dropdown == null:
			print('hey boss, the options menu can\'t find the dropdown menu to connect enabled_notes')
		else:
			connect('toggle_notes', dropdown, 'toggle_quest_log')
			
	if get_signal_connection_list('toggle_voicing').size() == 0:
		var tts_node = get_node('/root/main/game/tts_node')
		if tts_node == null:
			print('hey boss, the options menu can\'t find the tts node to connect enabled_voicing')
		else:
			connect('toggle_voicing', tts_node, 'toggle_voicing')
	
	return options_dict

func load_and_apply_options():
	# this is only called when the game starts and when you reset the settings
	var options_dict = load_options()
	_on_music_value_changed(options_dict['music_volume'])
	_on_sfx_value_changed(options_dict['sfx_volume'])
	_on_fullscreen_toggled(options_dict['fullscreen'])
	_on_text_size_value_changed(options_dict['text_size'])
	_on_enable_notes_toggled(options_dict['notes_enabled'])
	_on_enable_voicing_toggled(options_dict['voicing_enabled'])
	_on_window_size_selected(resolutions.find(options_dict['resolution']))

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
	print(db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), db)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), db == -80)
	
func math(value):
	if value == 0:
		return -80
	return 27 * log(value)/log(10) - 3 # max is -3 db

func _on_reset_pressed():
	var dir = Directory.new()
	dir.remove("user://options.save")
	load_and_apply_options()

# below are functions that apply changes to the options

func _on_music_value_changed(value):
	change_volume('Music', value)

func _on_sfx_value_changed(value):
	change_volume('SFX', value)
	
func _on_fullscreen_toggled(on):
	OS.window_fullscreen = on
	if not on:
		var res_id = $window_size/option_button.selected
		var res_string = resolutions[res_id]
		var res = res_string.split(' x ')
		OS.window_size = Vector2(int(res[0]), int(res[1]))
	
func _on_text_size_value_changed(value):
	$text_size/preview_b.get_font('normal_font').set_size(value)
	$text_size/preview_b.get_font('italics_font').set_size(value)
	var bb = $text_size/preview_b.get_bbcode()
	$text_size/preview_b.clear()
	$text_size/preview_b.set_bbcode(bb)

func _on_enable_notes_toggled(button_pressed):
	emit_signal('toggle_notes', button_pressed)
		
func _on_enable_voicing_toggled(button_pressed):
	emit_signal('toggle_voicing', button_pressed)

func _on_window_size_selected(ID):
	var res_string = resolutions[ID]
	var res = res_string.split(' x ')
	OS.window_size = Vector2(int(res[0]), int(res[1]))


func hide_custom():
	hide()
	emit_signal('hiding')
