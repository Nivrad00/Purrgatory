extends 'state_handler_template.gd'

var state = null

func _ready():
	state = get_node('../../../../..').state
	$exit_dialog.set_highlight_on_hover(true)
	
func play_default_music(state):
	if state.get('antechamber_portal') or state.get('postgame'):
		emit_signal('change_audio', '')
	else:			
		emit_signal('change_audio', default_music)
		
func update_state(state):
	.update_state(state)
	
	if state.get('antechamber_portal'):
		$portal.show()
		$exit_dialog.show()
		$exit.hide()
		if not $ambience.playing:
			$ambience.play()
	else:
		$portal.hide()
		$exit_dialog.hide()
		$exit.show()
		
	if state.get('end_fade_out_trigger') and $portal.visible:
		print('aaaaa')
		$portal_audio.play()
		$fadeout.show()

func _process(delta):
	if state.get('end_fade_out_trigger'):
		var a = $fadeout.get_modulate().a
		if a == 1:
			state['end_fade_out_trigger'] = false
			$white_timer.start()
			
			yield($white_timer, 'timeout')
			if state.get('oliver_quest_complete'):
				emit_signal('change_room', 'heaven1')
			else:
				emit_signal('change_room', 'bad_credits')
				
		else:
			a = min(a + 0.2 * delta, 1)
			$fadeout.set_modulate(Color(1, 1, 1, a))
			$ambience.volume_db = 5 - 85 * a
