extends 'state_handler_template.gd'

func _ready():
	$wait_library_door.set_highlight_on_hover(true)
	
func play_default_music(state):
	if state.get('called_lucifur'):
		emit_signal('change_audio', 'Lucifur')
	else:			
		emit_signal('change_audio', default_music)
		
func update_state(state):
	.update_state(state)
	
	$everything_slam_poster.hide()
	$poetry_slam_sign.hide()
	$commons2_fg.hide()
	$commons_chair2.hide()
	$commons_poem.hide()
	$tack.hide()
	
	if state.get('elijah_quest_complete'):
		$everything_slam_poster.show()
	else:
		$poetry_slam_sign.show()
		$commons2_fg.show()
		$commons_chair2.show()
		$commons_poem.show()
		$tack.show()
		
	
	if state.get('glunk'):
		state['glunk'] = false
		$glunk.play()
	
	if state.get('waiting'):
		$wait_elijah.show()
		$wait_kyungsoon.show()
		$wait_natalie.show()
		$wait_numa.show()
		$wait_oliver.show()
		$wait_sean.show()
		$wait_tori.show()
		$wait_library_door.show()
		$library_door.hide()
		$seans_chair.show()
		$elijahs_chair.show()
		$commons_chair1.hide()
	else:
		$wait_elijah.hide()
		$wait_kyungsoon.hide()
		$wait_natalie.hide()
		$wait_numa.hide()
		$wait_oliver.hide()
		$wait_sean.hide()
		$wait_tori.hide()
		$wait_library_door.hide()
		$library_door.show()
		$seans_chair.hide()
		$elijahs_chair.hide()
		$commons_chair1.show()
	
	if state.get('elijah_interviewing'):
		$wait_elijah.hide()
	if state.get('kyungsoon_interviewing'):
		$wait_kyungsoon.hide()
	if state.get('natalie_interviewing'):
		$wait_natalie.hide()
	if state.get('numa_interviewing'):
		$wait_numa.hide()
	if state.get('oliver_interviewing'):
		$wait_oliver.hide()
	if state.get('sean_interviewing'):
		$wait_sean.hide()
	if state.get('tori_interviewing'):
		$wait_tori.hide()
	
	if state.get('waited_once'):
		state['waited_once'] = false
		if state.has('wait_amount'):
			state['wait_amount'] += 1
		else:
			state['wait_amount'] = 1
		
		if state['wait_amount'] == 2:
			emit_signal('start_dialog', 'lucifur_calls_natalie', [])
		elif state['wait_amount'] == 4:
			emit_signal('start_dialog', 'lucifur_calls_oliver', [])
		elif state['wait_amount'] == 6:
			emit_signal('start_dialog', 'lucifur_calls_kyungsoon', [])
		elif state['wait_amount'] == 8:
			emit_signal('start_dialog', 'lucifur_calls_numa', [])
		elif state['wait_amount'] == 10:
			emit_signal('start_dialog', 'lucifur_calls_tori', [])
		elif state['wait_amount'] == 12:
			emit_signal('start_dialog', 'lucifur_calls_sean', [])
		elif state['wait_amount'] >= 14:
			emit_signal('start_dialog', 'lucifur_calls_player', [])
