extends 'state_handler_template.gd'

var state = null

func _ready():
	state = get_node('../../../../..').state
	$object.set_highlight_on_hover(true)
	set_process(true)
	
func update_state(state):
	.update_state(state)
		
	if state.get('enter_gate'):
		# print('aaaaa')
		$door_audio.play()
		$fadeout.show()

func _process(delta):
	if state.get('enter_gate'):
		var a = $fadeout.get_modulate().a
		if a == 1:
			state['enter_gate'] = false
			$white_timer.start()
			emit_signal('change_audio', '')
			if get_node('../../../../..').main_audio:
				get_node('../../../../..').main_audio.volume_db = -6
			
			yield($white_timer, 'timeout')
			emit_signal('change_room', 'good_credits')
			
				
		else:
			a = min(a + 0.4 * delta, 1)
			$fadeout.set_modulate(Color(1, 1, 1, a))
			if get_node('../../../../..').main_audio:
				get_node('../../../../..').main_audio.volume_db = -6 - 78 * a
