extends 'state_handler_template.gd'

func _ready():
	# if you've already done the mural, replace the viewporttexture with an imagetexture
	# i guess we're doing the terrible path again...
	var img = get_node("../../../../..").mural_drawing
	if img:
		$draw/draw_texture.texture = ImageTexture.new()
		$draw/draw_texture.texture.create_from_image(img)
	
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
		emit_signal('start_action_timer', 50, ['natalie_working_on_nocturnal', true])
		
	if state.get('start_drawing'):
		state['start_drawing'] = false
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

func stop_drawing():
	$draw.disable()
	$draw.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$draw/draw_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$cover2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$done_button.hide()
	
	var img = $draw/draw_texture.get_texture().get_data()
	get_node("../../../../..").mural_drawing = img
	
	emit_signal('start_dialog', 'natalie_after_drawing', [])