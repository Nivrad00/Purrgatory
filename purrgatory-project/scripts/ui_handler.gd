extends Control

var sprite_y = 280
var sprite_x = {
	1: [640],
	2: [426.67, 853.33],
	3: [320, 640, 960],
	4: [256, 512, 768, 1024]
}
var choice_y = {
	1: [150],
	2: [100, 200],
	3: [75, 150, 225],
	4: [45, 115, 185, 255]
}

# i was thinking about color-coding the names but i changed my mind
var speaker_colors = {
	'numa': Color('#a13431'),
	'tori': Color('#ac4e0c'),
	'oliver': Color('#786c00'),
	'natalie': Color('#0d9393'),
	'kyungsoon': Color('#5539ab'),
	'elijah': Color('#8331a2')
}

onready var game = get_node("../..")
onready var tts_node = game.get_node('tts_node')
var book_singleton

func _ready():
	hide_ui()
	# hide the book in the corner
	book_singleton = load('res://scenes/sprites/book.tscn').instance()
	book_singleton.set_name('book')
	book_singleton.scale = Vector2(0.001, 0.001)
	book_singleton.modulate.a = 0.01
	book_singleton.position = Vector2(0, 0)
	$sprites.add_child(book_singleton)
	
	# we need to disable automatic translation on the speaker box and text box because
	#   dialog translation is handled separately from godot's built in translation system
	#   (mainly because i handled it before i knew about godot's built in translation system)
	var text_box = get_node("text_box/text")
	text_box.set_message_translation(false)
	text_box.notification(NOTIFICATION_TRANSLATION_CHANGED)
	var speaker_box = get_node("text_box/speaker")
	speaker_box.set_message_translation(false)
	speaker_box.notification(NOTIFICATION_TRANSLATION_CHANGED)
	
func show_ui():
	show()

func hide_ui():
	update_ui('', [], '', [])
	hide()

# tts is usually true, but is false when loading a game (bc it shouldn't immediately speak it)
func update_ui(speaker, sprites, text, choices, tts = true):
	if speaker != null:
		set_speaker(speaker)
	if sprites != null:
		set_sprites(sprites)
	if text != null:
		set_text(text)
	set_choices(choices)

	# if either the speaker or text changes, and there IS a speaker or text...
	# a) save the current speaker and text to history
	if (speaker != null or text != null) and (get_speaker() != '' or get_text() != ''):
		game.get_node('meta_ui/history').add_to_history(get_speaker(), get_text())

	# do tts if tts is enabled and skip is off
	tts_node.stop()
	if tts:
		# only speak the speaker/text if it's changed
		yield(get_tree(), "idle_frame")
		speak_ui(speaker != null or text != null)

func speak_ui(all = true):
	if game.skip:
		return

	var speaker = get_speaker()
	var text = get_text()
	var choices = get_choices()

	if all:
		tts_node.speak(speaker + ', ' + text)

	if choices.size() > 0:
		var i = 1
		var spoken_text = ''
		for choice in choices:
			spoken_text += str(i) + ', ' + choice + '. '
			i += 1
		tts_node.speak(spoken_text)

func set_speaker(speaker):
	speaker = speaker.strip_edges()
	$text_box/speaker.text = speaker
	
	#if speaker in speaker_colors:
	#	$text_box/speaker.add_color_override("font_color", speaker_colors[speaker])
	#else:
	#	$text_box/speaker.add_color_override("font_color", Color(0, 0, 0))
		
	if speaker.length() == 0:
		$text_box/speech_box.hide()
		$text_box/speaker.hide()
		$text_box/narration_box.show()
		$text_box/text.rect_position.y = 36
	else:
		$text_box/speech_box.show()
		$text_box/speaker.show()
		$text_box/narration_box.hide()
		$text_box/text.rect_position.y = 84
		

func set_sprites(sprites):
	for child in $sprites.get_children():
		if child.name != 'book':
			child.name += '_deleted'
			child.queue_free()

	# wait for an idle frame so the new sprites will have the correct name
	# yield(get_tree(), "idle_frame")
	# nvm - we're just renaming the old sprites
	
	var num = sprites.size()
	for i in range(num):
		if sprites[i] == 'book' and book_singleton:
			book_singleton.scale = Vector2(1, 1)
			book_singleton.modulate.a = 1
			book_singleton.position = Vector2(sprite_x[num][i], sprite_y)
			continue
		
		var sprite = load('res://scenes/sprites/' + sprites[i] + '.tscn')
		if sprite:
			sprite = sprite.instance()
		else:
			continue
			
		sprite.set_name(sprites[i])
		sprite.position = Vector2(sprite_x[num][i], sprite_y)
		$sprites.add_child(sprite)
	
	if not sprites.has('book') and book_singleton:
		book_singleton.load_meows() # refresh meows when it's hidden for next time
		book_singleton.scale = Vector2(0.001, 0.001)
		book_singleton.modulate.a = 0.01
		book_singleton.position = Vector2(0, 0)
		

func set_text(text):
	$text_box/text.text = text
	$text_box/text.bbcode_text = text

func set_choices(choices):
	var num = choices.size()
	for child in $choices.get_children():
		child.queue_free()

	if num == 0:
		$text_box.disabled = false
		return

	$text_box.disabled = true
	for i in range(num):
		var choice = load('res://scenes/choice' + String(i) + '.tscn').instance()
		choice.get_node('text').set_text(choices[i])
		choice.connect("pressed", game, "update_dialog", [i])
		choice.set_position(Vector2(0, choice_y[num][i]))
		$choices.add_child(choice)

func get_speaker():
	return $text_box/speaker.text

func get_sprites():
	var sprite_names = []
	for sprite in $sprites.get_children():
		if sprite.name == 'book':
			if sprite.scale.x == 1:
				sprite_names.append(sprite.name)
		else:
			sprite_names.append(sprite.name)
	return sprite_names

func get_text():
	return $text_box/text.bbcode_text

func get_choices():
	var choices_text = []
	for choice_box in $choices.get_children():
		choices_text.append(choice_box.get_node('text').text)
	return choices_text
