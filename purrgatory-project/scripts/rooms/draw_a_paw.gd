extends 'state_handler_template.gd'

func erase():
	$paw/AnimationPlayer.play("shake")

func clear():
	$paw/draw/draw_viewport/pen.to_erase = true
	$paw/draw/loaded_texture.texture = null

func back():
	store_image()
	emit_signal('change_room', '_prev')

func _ready():
	var game = get_node('../../../../..')
	
	if game.draw_a_paw_drawing:
		var img = game.draw_a_paw_drawing
		$paw/draw/loaded_texture.texture = ImageTexture.new()
		$paw/draw/loaded_texture.texture.create_from_image(img)

func store_image():
	var img_new = $paw/draw/draw_texture.texture.get_data()
	var img = null
	
	if $paw/draw/loaded_texture.texture:
		img = $paw/draw/loaded_texture.texture.get_data()
		img.blend_rect(img_new, Rect2(Vector2(0, 0), Vector2(1280, 720)), Vector2(0,0))
	else:
		img = img_new
	
	var game = get_node('../../../../..')
	game.draw_a_paw_drawing = img
	game.state['draw_a_paw_x'] = $paw/draw.prev_pos.x
	game.state['draw_a_paw_y'] = $paw/draw.prev_pos.y
	
