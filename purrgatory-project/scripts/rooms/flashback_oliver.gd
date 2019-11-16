extends "state_handler_template.gd"

var n = 0

func update_state(state):
	.update_state(state)
	if state.get('flashback_goto_commons'):
		emit_signal('change_room', 'commons1')
	
func next():
	if n < $text_container.get_children().size():
		var current = $text_container.get_child(n)
		current.get_node('AnimationPlayer').play("Fadein")
		n += 1
		
		if current.name[0] == 't':
			$next_cover.show()
			$next_button.hide()
		elif current.name[0] == 'c':
			$next_cover.hide()
			$next_timer.start()
			
	else: 
		for child in $text_container.get_children():
			child.get_node('AnimationPlayer').play_backwards("Fadein")
			$wake_up_cover.show()

func show_next_button():
	$next_button.modulate.a = 0
	$next_button.get_node('text').set_bbcode('[center]next[/center]')
	$next_button.show()
	$next_button.get_node('AnimationPlayer').play("Fadein")

func wake_up():
	emit_signal('start_dialog', 'oliver_end_pride_flashback', [])
