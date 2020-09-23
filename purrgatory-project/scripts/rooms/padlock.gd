extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	
	if not state.get('tried_meowseum_door'):
		emit_signal('start_dialog', 'see_padlock', [])
	
func _on_submit_pressed():
	if $numbers/digit1.frame == 1\
	and $numbers/digit2.frame == 2\
	and $numbers/digit3.frame == 3\
	and $numbers/digit4.frame == 4:
		$unlock.play()
		$bg2.show()
		$numbers.position.y += 83
		$submit.rect_position.y += 83
		emit_signal('start_dialog', 'open_padlock', [])