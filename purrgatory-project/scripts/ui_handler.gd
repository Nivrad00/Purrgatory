extends Control

var sprite_y = 280
var sprite_x = {
	1: [640],
	2: [426.67, 853.33],
	3: [320, 640, 960],
	4: [256, 512, 1024, 2048]
}
var choice_y = {
	1: [150],
	2: [100, 200],
	3: [75, 150, 225],
	4: [45, 115, 185, 255]
}

onready var game = get_node("../..")
onready var tts_node = game.get_node('tts_node')

func _ready():
	hide_ui()

func hide_ui():
	update_ui('', [], '', [])
	hide()
	
func update_ui(speaker, sprites, text, choices):
	if speaker != null:
		set_speaker(speaker)
	if sprites != null:
		set_sprites(sprites)
	if text != null:
		set_text(text)
	set_choices(choices)
	
	# if either the speaker or text changes, and there IS a speaker or text...
	# a) save the current speaker and text to history
	# b) speak it through tts, if enabled
	if (speaker != null or text != null) and (get_speaker() != '' or get_text() != ''):
		game.get_node('meta_ui/history').add_to_history(get_speaker(), get_text())
	
	# handle tts stuff here, unless it's disabled or skip is on
	tts_node.stop()
	if game.skip:
		return
	
	if speaker != null and speaker != '':
		tts_node.speak(speaker)
		
	if text != null and text != '':
		tts_node.speak(text)
	
	for choice in choices:
		tts_node.speak(choice)

func set_speaker(speaker):
	$text_box/speaker.text = speaker
	
func set_sprites(sprites):	
	for child in $sprites.get_children():
		child.queue_free()
		
	var num = sprites.size()
	for i in range(num):
		var sprite = load('res://scenes/sprites/' + sprites[i] + '.tscn')
		if sprite:
			sprite = sprite.instance()
		else:
			continue
		sprite.set_name(sprites[i])
		sprite.position = Vector2(sprite_x[num][i], sprite_y)
		$sprites.add_child(sprite)
	
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
		sprite_names.append(sprite.name)
	return sprite_names

func get_text():
	return $text_box/text.bbcode_text
	
func get_choices():
	var choices_text = []
	for choice_box in $choices.get_children():
		choices_text.append(choice_box.get_node('text').text)
	return choices_text