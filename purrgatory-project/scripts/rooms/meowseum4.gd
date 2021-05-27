extends 'state_handler_template.gd'

func update_state(state):
	.update_state(state)
	
	var met_everyone = state.get('met_kyungsoon') and\
		state.get('met_oliver') and\
		state.get('met_numa') and\
		state.get('met_sean') and\
		state.get('met_elijah') and\
		state.get('met_tori') and\
		state.get('met_natalie')
	
	$maine_coon_broken.hide()
	$maine_coon.hide()
	if not state.get('sean_broke_sculpture'):
		$maine_coon.show()
	else:
		$maine_coon_broken.show()
	
	$meowseum_broom.hide()
	if state.get('sean_went_to_piano') and met_everyone:
		$meowseum_broom.show()
	
	$sean_meowseum.hide()
	$sean_sus.hide()
	$elijah_sweeping.hide()
	$elijah_floor.hide()
	$elijah_planning.hide()
	if not state.get('opened_meowseum_door'):
		pass
	if not state.get('sean_broke_sculpture'):
		$sean_meowseum.show()
	elif not state.get('sean_went_to_piano'):
		$sean_sus.show()
	elif not met_everyone:
		$elijah_sweeping.show()
	elif not state.get('elijah_planning_slam'):
		$elijah_floor.show()
	elif not state.get('ready_for_slam') and not state.get('did_slam'):
		$elijah_planning.show()
	
	# oliver's date overrides them
	if state.get('oliver_on_date'):
		$sean_meowseum.hide()
		$sean_sus.hide()
		$elijah_sweeping.hide()
		$elijah_floor.hide()
		$elijah_planning.hide()
		
	if state.get('oliver_goto_meowseum3'):
		state['oliver_goto_meowseum3'] = false
		emit_signal('change_room', 'meowseum1')