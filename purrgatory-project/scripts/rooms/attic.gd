extends 'state_handler_template.gd'
	
func update_state(state):
	.update_state(state)
	
	if state.get('natalie_drawing_timer1'):
		state['natalie_drawing_timer1'] = false
		emit_signal('start_action_timer', 40, ['natalie_finished_drawing1', true])
		
	if state.get('natalie_drawing_timer2'):
		state['natalie_drawing_timer2'] = false
		emit_signal('start_action_timer', 40, ['natalie_finished_drawing2', true])
		
	if state.get('natalie_drawing_timer3'):
		state['natalie_drawing_timer3'] = false
		emit_signal('start_action_timer', 40, ['natalie_finished_drawing3', true])
		
	$natalie_idle.hide()
	$natalie_sleeping.hide()
	$natalie_nocturnal.hide()
	
	$bg.hide()
	$bg2.hide()
	$bg3.hide()
	
	$attic_books.hide()
	$attic_pencil_box.hide()
	
	for node in get_children():
		if node.name.substr(0, 4) == 'post':
			node.hide()
	
	if state.get('natalie_completed_mural'):
		$natalie_nocturnal.show()
		$bg3.show()
		$attic_pencil_box.show()
		for node in get_children():
			if node.name.substr(0, 4) == 'post':
				node.show()
			
	elif state.get('saw_natalie_intro'):
		$natalie_idle.show()
		$bg2.show()
		$attic_pencil_box.show()
		
	else:
		$natalie_sleeping.show()
		$bg.show()
		$attic_books.show()
		
	if state.get('show_natalie'):
		if $natalie_idle.visible:
			emit_signal('set_hidden_sprite', [$natalie_idle])
		elif $natalie_nocturnal.visible:
			emit_signal('set_hidden_sprite', [$natalie_nocturnal])
		state['show_natalie'] = false
	
	if state.get('blackout'):
		$attic_candles_on.show()
		$attic_candles.hide()
	else:
		$attic_candles_on.hide()
		$attic_candles.show()