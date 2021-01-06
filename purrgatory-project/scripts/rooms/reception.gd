extends 'state_handler_template.gd'

var state = null

func _ready():
	state = get_node('../../../../..').state
	
func update_state(state):
	.update_state(state)
	$fadeout.hide()
		
	if state.get('enable_name_input'):
		# this is the worst but i don't feel like fixing it
		get_node('../../../../ui/name_input').show()
		get_node('../../../../ui/text_box').disabled = true
		get_node('../../../../ui/name_input/text').grab_focus()
		
	if state.get('met_receptionist'):
		state['charon_moving'] = true
		$receptionist_idle.hide()
		$elbow.hide()
		$receptionist_idle2.show()
	
	if state.get('fade_out_trigger') and $portal.visible:
		print('aaaaa')
		$portal_audio.play()
		$portal.hide()
		$fadeout.show()

func _process(delta):
	if state.get('charon_moving'):
		var pos = $receptionist_idle2.get_position()
		$receptionist_idle2.set_position(Vector2(pos.x - 5 * delta, pos.y))
	if state.get('fade_out_trigger'):
		var a = $fadeout.get_modulate().a
		if a == 1:
			state['fade_out_trigger'] = false
			$white_timer.start()
			
			yield($white_timer, 'timeout')
			emit_signal('change_room', 'antechamber1')
		else:
			a = min(a + 0.2 * delta, 1)
			$fadeout.set_modulate(Color(1, 1, 1, a))
			$ambience.volume_db = 5 - 85 * a
