extends Node2D

var sprite_y = 280

func _ready():
	hide()
	$text_box/text.text = ''
	$text_box/speaker.text = ''

func update_ui(speaker, sprites, text, choices):
	print("hewwo???????????")
	set_speaker(speaker)
	set_sprites(sprites)
	set_text(text)
	set_choices(choices)

func set_speaker(speaker):
	$text_box/speaker.text = speaker
	
func set_sprites(sprites):
	var num = sprites.size()
	var pos
	
	if num == 1:
		pos = [640] 
	elif num == 2:
		pos = [426.67, 853.33]
	elif num == 3:
		pos = [320, 640, 960]
	elif num == 4:
		pos = [256, 512, 1024, 2048]
	
	for child in $sprites.get_children():
		child.queue_free()
	
	for path in sprites:
		var sprite = load('res://scenes/' + path + '.tscn').instance()
		sprite.set_name(path)
		sprite.position = Vector2(pos.pop_front(), sprite_y)
		$sprites.add_child(sprite)
	
func set_text(text):
	$text_box/text.text = text
	
func set_choices(choices):
	pass	