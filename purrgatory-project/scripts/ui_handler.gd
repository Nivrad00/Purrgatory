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
	4: [60, 120, 180, 240]
}

func _ready():
	hide()
	update_ui('', [], '', [])

func update_ui(speaker, sprites, text, choices):
	set_speaker(speaker)
	set_sprites(sprites)
	set_text(text)
	set_choices(choices)

func set_speaker(speaker):
	$text_box/speaker.text = speaker
	$text_box/speaker.bbcode_text = speaker
	
func set_sprites(sprites):
	for child in $sprites.get_children():
		child.queue_free()
		
	var num = sprites.size()
	for i in range(num):
		var sprite = load('res://scenes/characters/' + sprites[i] + '.tscn')
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
	if num == 0:
		$text_box.disabled = false
		for child in $choices.get_children():
			child.queue_free()
		return
		
	$text_box.disabled = true
	for i in range(num):
		var choice = load('res://scenes/choice' + String(i) + '.tscn').instance()
		choice.get_node('text').text = choices[i]
		choice.connect("pressed", get_node("/root/game"), "update_dialog", [i])
		choice.set_position(Vector2(0, choice_y[num][i]))
		$choices.add_child(choice)