extends 'state_handler_template.gd'

func init_state(state):
	.init_state(state)
	if state.get('oliver_why'):
		state['oliver_why'] = false
		
func update_state(state):
	.update_state(state)
		
	if state.get('oliver_sleeping'):
		$oliver_asleep_at_desk.hide()
		$oliver_study.hide()
		$oliver_sleeping.show()
		$chair1.show()
		$chair2.hide()
	elif state.get('house_cat_pushed_glass'):
		$oliver_asleep_at_desk.show()
		$oliver_study.hide()
		$oliver_sleeping.hide()
		$chair1.hide()
		$chair2.show()
	elif state.get('oliver_in_study'):
		$oliver_asleep_at_desk.hide()
		$oliver_study.show()
		$oliver_sleeping.hide()
		$chair1.hide()
		$chair2.show()
	else:
		$chair1.show()
		$chair2.hide()
		$oliver_study.hide()
		$oliver_sleeping.hide()
		$oliver_asleep_at_desk.hide()
		
	if state.get('oliver_why'):
		$oliver_study.hide()
		
	if state.get('hide_oliver_custom'):
		state['hide_oliver_custom'] = false
		emit_signal('set_hidden_sprite', [$oliver_study])
		
	if state.get('show_oliver_asleep_at_desk'):
		state['show_oliver_asleep_at_desk'] = false
		emit_signal('set_hidden_sprite', [])
		
	if state.get('oliver_goto_park1'):
		state['oliver_goto_park1'] = false
		emit_signal('change_room', 'field1')
		
	if state.get('oliver_goto_meowseum1'):
		state['oliver_goto_meowseum1'] = false
		emit_signal('change_room', 'meowseum2')
		
	if state.get('oliver_goto_dropoff1'):
		state['oliver_goto_dropoff1'] = false
		emit_signal('change_room', 'hallway4')
