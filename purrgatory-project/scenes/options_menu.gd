extends Control

signal options_changed()
signal toggle_notes(on)
signal toggle_voicing(on)
signal hiding()
signal change_voice_speed(value)

var resolutions = [
	'854 x 480',
	'1024 x 576',
	'1280 x 720',
	'1600 x 900',
	'1920 x 1080'
]

var quips = [
	['cat', 
		['meow meow, meow meow meow :3',
		'miau miau, miau miau miau :3',
		'喵喵，喵喵喵 :3']
	],
	['oliver', 
		['to meow, or not to meow, that is the question!',
		'¿no es cierto, ángel de amor, que en esta apartada orilla más pura la luna brilla y se maúlla mejor?',
		'是要喵，还是不要喵，这是问题所在！']
	],
	['kyungsoon', 
		['hmmm. that\'s an options menu',
		'hum. pues un menú de opciones',
		'嗯——这是个设置菜单']
	],
	['numa', 
		['HEY!! change the font size right now! i mean... if you want.',
		'¡OYE! ¡ya estás cambiando el tamaño de la letra! bueno... si te apetece.',
		'嘿！！快改一下字体大小！我是说…如果你想的话']
	],
	['sean', 
		['what\'s a nice player like you doing in a menu like this? (;',
		'y... ¿vienes mucho por este menú de opciones? (;',
		'你这样可爱的玩家在菜单里做什么呢 (;']
	],
	['elijah', 
		['\'tis better to have meowed and lost than never to have meowed at all.',
		'que toda la vida es un gato, y los gatos, gatos son.',
		'喵过却失去，总比从未喵过好']
	],
	['tori', 
		['what are you doing fiddling with the settings? there\'s a game to play!',
		'¿se puede saber qué haces mirando la configuración? ¡ponte a jugar!',
		'你怎么还在这摆弄设置？还有游戏要玩！']
	],
	['natalie', 
		['zzz... huh? where am i?',
		'zzz... ¿eing? ¿dónde estoy?',
		'zzz…哎？咱在哪？']
	]
]

var default_options = {
	"fullscreen": false,
	"music_volume": 0.6,
	"sfx_volume": 0.6,
	"text_size": 24,
	"notes_enabled": true,
	"voicing_enabled": false,
	"resolution": "1280 x 720",
	"voice_speed": 1.0,
	"low_contrast": false,
	"language": 0 # english
}

func _ready():
	# handle web build
	
	if get_tree().get_root().get_node('main').web_build:
		$right_side/fullscreen_label.modulate.a = 0.3
		$right_side/fullscreen.modulate.a = 0.3
		$right_side/fullscreen.disabled = true
		
		$right_side/window_size_label.modulate.a = 0.3
		$right_side/window_size.modulate.a = 0.3
		$right_side/window_size/dropdown.disabled = true
		
		$right_side/self_voicing_label.modulate.a = 0.3
		$right_side/self_voicing.modulate.a = 0.3
		$right_side/self_voicing.disabled = true
		$right_side/self_voicing/test_voicing.disabled = true
		
		$right_side/voice_speed_label.modulate.a = 0.3
		$right_side/voice_speed.modulate.a = 0.3
		$right_side/voice_speed/slider.editable = false
		
		$web_disclaimer.show()
		$download_disclaimer.hide()
	
	else:
		$right_side/fullscreen_label.modulate.a = 1
		$right_side/fullscreen.modulate.a = 1
		$right_side/fullscreen.disabled = false
		
		$right_side/window_size_label.modulate.a = 1
		$right_side/window_size.modulate.a = 1
		$right_side/window_size/dropdown.disabled = false
		
		$right_side/self_voicing_label.modulate.a = 1
		$right_side/self_voicing.modulate.a = 1
		$right_side/self_voicing.disabled = false
		$right_side/self_voicing/test_voicing.disabled = false
		
		$right_side/voice_speed_label.modulate.a = 1
		$right_side/voice_speed.modulate.a = 1
		$right_side/voice_speed/slider.editable = true
		
		$web_disclaimer.hide()
		$download_disclaimer.show()
	
	# load in resolution and language options
	
	for res in resolutions:
		$right_side/window_size/dropdown.add_item(res)
	
	for lang in Language.languages:
		$language/language/dropdown.add_item(lang)
		
	Language.connect("language_changed", self, "_on_language_changed")
		
func save_options():
	# saves options to file
	# (the options are applied as soon as the values are changed or the game starts, so no need to apply anything here)
	# this method is called when the options menu closes
	
	var options_dict = {
		"fullscreen": $right_side/fullscreen.pressed,
		"music_volume": $audio/music.value,
		"sfx_volume": $audio/sfx.value,
		"text_size": $text_size/slider.value,
		"notes_enabled": $right_side/to_do.pressed,
		"voicing_enabled": $right_side/self_voicing.pressed,
		"resolution": resolutions[$right_side/window_size/dropdown.selected],
		"voice_speed": $right_side/voice_speed/slider.value,
		"low_contrast": $right_side/low_contrast.pressed,
		"language": Language.language 
		# unlike the others options, language is based on the global Language rather than the local UI
		# since there are multiple locations where you can change it
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
	var options_dict = default_options.duplicate()
	
	if options_save.file_exists("user://options.save"):
		options_save.open("user://options.save", File.READ)
		var options_save_dict = parse_json(options_save.get_line())
		options_save.close()
	
		for key in options_save_dict:
			options_dict[key] = options_save_dict[key]
	
	# take extra care with language for compatibility with old versions
	if not options_dict.has('language'):
		options_dict['language'] = 0
		
	$right_side/fullscreen.pressed = options_dict['fullscreen']
	$audio/music.value = options_dict['music_volume']
	$audio/sfx.value = options_dict['sfx_volume']
	$text_size/slider.value = options_dict['text_size']
	$right_side/to_do.pressed = options_dict['notes_enabled']
	$right_side/self_voicing.pressed = options_dict['voicing_enabled']
	$right_side/window_size/dropdown.selected = resolutions.find(options_dict['resolution'])
	$right_side/voice_speed/slider.value = options_dict['voice_speed']
	$right_side/low_contrast.pressed = options_dict['low_contrast']
	$language/language/dropdown.selected = options_dict['language']
	
	# also, connect the to-do and tts options if not done already
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
			connect('change_voice_speed', tts_node, 'change_voice_speed')
	
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
	_on_slider_value_changed(options_dict['voice_speed'])
	_on_low_contrast_toggled(options_dict['low_contrast'])
	_on_language_selected(options_dict['language'])

func show_custom():
	var state = get_node('/root/main/game').state
	
	var available_quips = [quips[0]]
	for quip in quips:
		if state.get('met_' + quip[0]):
			available_quips.append(quip)
			
	var current_quip = available_quips[randi() % available_quips.size()]
	
	# set the speaker
	# there are exceptions for chinese, which has unique character names, and "cat" in spanish
	if Language.language == 2:
		match current_quip[0]:
			'natalie':
				$text_size/preview_a.set_text('娜塔丽')
			'kyungsoon':
				$text_size/preview_a.set_text('京纯')
			'oliver':
				$text_size/preview_a.set_text('奥利弗')
			'numa':
				$text_size/preview_a.set_text('纽玛')
			'elijah':
				$text_size/preview_a.set_text('伊莱贾')
			'sean':
				$text_size/preview_a.set_text('肖恩')
			'tori':
				$text_size/preview_a.set_text('托丽')
			'cat':
				$text_size/preview_a.set_text('猫')
	elif current_quip[0] == "cat" and Language.language == 1:
		$text_size/preview_a.set_text("gato")
	else:
		$text_size/preview_a.set_text(current_quip[0])
	
	# set the quip
	$text_size/preview_b.set_bbcode(current_quip[1][Language.language])
	
	load_options()
	show()

# need to choose a new quip if the language is changed
func _on_language_changed(lang):
	var state = get_node('/root/main/game').state
	
	var available_quips = [quips[0]]
	for quip in quips:
		if state.get('met_' + quip[0]):
			available_quips.append(quip)
			
	var current_quip = available_quips[randi() % available_quips.size()]
	
	# set the speaker
	# there are exceptions for chinese, which has unique character names, and "cat" in spanish
	if lang == 2:
		match current_quip[0]:
			'natalie':
				$text_size/preview_a.set_text('娜塔丽')
			'kyungsoon':
				$text_size/preview_a.set_text('京纯')
			'oliver':
				$text_size/preview_a.set_text('奥利弗')
			'numa':
				$text_size/preview_a.set_text('纽玛')
			'elijah':
				$text_size/preview_a.set_text('伊莱贾')
			'sean':
				$text_size/preview_a.set_text('肖恩')
			'tori':
				$text_size/preview_a.set_text('托丽')
			'cat':
				$text_size/preview_a.set_text('猫')
	elif current_quip[0] == "cat" and lang == 1:
		$text_size/preview_a.set_text("gato")
	else:
		$text_size/preview_a.set_text(current_quip[0])
	
	# set the quip
	$text_size/preview_b.set_bbcode(current_quip[1][Language.language])
	
func change_volume(bus, volume):
	var db = math(volume)
	# print(db)
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
		var res_id = $right_side/window_size/dropdown.selected
		var res_string = resolutions[res_id]
		var res = res_string.split(' x ')
		OS.window_size = Vector2(int(res[0]), int(res[1]))
	
func _on_text_size_value_changed(value):
	# dialog font
	$text_size/preview_b.get_font('normal_font').set_size(value)
	$text_size/preview_b.get_font('italics_font').set_size(value)
	# this font is used in the main menu credits, bc it needs to be resized
	#  like the dialog font is, but it also needs to stay in chinese
	preload("res://themes/chinese_only_dialog_font.tres").set_size(value)
	
	var bb = $text_size/preview_b.get_bbcode()
	$text_size/preview_b.clear()
	$text_size/preview_b.set_bbcode(bb)

func _on_enable_notes_toggled(button_pressed):
	emit_signal('toggle_notes', button_pressed)
		
func _on_enable_voicing_toggled(button_pressed):
	emit_signal('toggle_voicing', button_pressed)
	if button_pressed:
		$right_side/self_voicing/test_voicing.show()
	else:
		$right_side/self_voicing/test_voicing.hide()

func _on_test_voicing_pressed():
	get_tree().get_root().get_node('main/game/tts_node').stop()
	if Language.language == 0:
		get_tree().get_root().get_node('main/game/tts_node').speak('self-voicing sample')
	elif Language.language == 1:
		get_tree().get_root().get_node('main/game/tts_node').speak('prueba del lector de pantalla')
	elif Language.language == 2:
		get_tree().get_root().get_node('main/game/tts_node').speak('(placeholder) self-voicing sample')

func _on_window_size_selected(ID):
	var res_string = resolutions[ID]
	var res = res_string.split(' x ')
	OS.window_size = Vector2(int(res[0]), int(res[1]))

# this one is tts speed
func _on_slider_value_changed(value):
	emit_signal('change_voice_speed', value)

func hide_custom():
	hide()
	emit_signal('hiding')

func _on_low_contrast_toggled(button_pressed):
	var filter = get_tree().get_root().get_node('main/low_contrast_filter')
	if button_pressed:
		filter.show()
	else:
		filter.hide()

func _on_language_selected(ID):
	Language.set_language(ID)
