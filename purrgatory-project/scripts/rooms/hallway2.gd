extends 'state_handler_template.gd'

var audio_pos = 0

func _ready():
	# if you've already done the mural, replace the viewporttexture with an imagetexture
	# i guess we're doing the terrible path again...
	var game = get_node("../../../../..")
	
	var img = game.mural_drawing
	if img:
		$draw/loaded_texture.texture = ImageTexture.new()
		$draw/loaded_texture.texture.create_from_image(img)
	
	if game.state.get('mural_drawing'):
		start_drawing()
		
	$draw.connect('drew_line', self, 'start_audio')
	
func update_state(state):
	.update_state(state)
	
	if state.get('natalie_completed_mural'):
		$object2.show()
	else:
		$object2.hide()
		
	if state.get('natalie_completed_mural') and not state.get('natalie_working_on_nocturnal'):
		$natalie_and_tori.show()
	else:
		$natalie_and_tori.hide()
		
	if state.get('natalie_tori_talking_timer'):
		state['natalie_tori_talking_timer'] = false
		emit_signal('start_action_timer', 40, ['natalie_working_on_nocturnal', true])
		
	if state.get('start_drawing'):
		state['start_drawing'] = false
		state['mural_drawing'] = true
		$draw.enable()
		$draw.mouse_filter = Control.MOUSE_FILTER_PASS
		$draw/draw_texture.mouse_filter = Control.MOUSE_FILTER_PASS
		$cover.mouse_filter = Control.MOUSE_FILTER_STOP
		$cover2.mouse_filter = Control.MOUSE_FILTER_STOP
		$done_button.show()
	
	if state.get('natalie_chose_cat'):
		$natalies_drawings/cat.show()
	if state.get('natalie_chose_dragon'):
		$natalies_drawings/dragon.show()
	if state.get('natalie_chose_spongebob'):
		$natalies_drawings/spongebob.show()

func start_drawing():
	$draw.enable()
	$draw.mouse_filter = Control.MOUSE_FILTER_PASS
	$draw/draw_texture.mouse_filter = Control.MOUSE_FILTER_PASS
	$cover.mouse_filter = Control.MOUSE_FILTER_STOP
	$cover2.mouse_filter = Control.MOUSE_FILTER_STOP
	$done_button.show()
	
func stop_drawing():
	$draw.disable()
	$draw.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$draw/draw_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$cover2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$done_button.hide()
	get_node("../../../../..").state['mural_drawing'] = false
	
	store_image()
	
	emit_signal('start_dialog', 'natalie_after_drawing', [])

func store_image():
	var texture = $draw/draw_texture.texture
	var final_img = null
	
	if texture:
		var new_img = texture.get_data()
		
		if $draw/loaded_texture.texture:
			final_img = $draw/loaded_texture.texture.get_data()
			final_img.blend_rect(new_img, Rect2(Vector2(0, 0), Vector2(1280, 720)), Vector2(0,0))
		else:
			final_img = new_img
		
	get_node("../../../../..").mural_drawing = final_img
	
func start_audio(_a, _b):
	print('starting audio')
	if not $asmr.playing:
		$asmr.play(audio_pos)
	$audio_delay.start()

func stop_audio():
	print('stopping audio')
	audio_pos = $asmr.get_playback_position()
	$asmr.stop()
