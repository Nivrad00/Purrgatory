extends 'state_handler_template.gd'

var state_copy = null
var anim_playing = false

func _ready():
	$phone.set_highlight_on_hover(false)
	state_copy = get_node('../../../../..').state
	if state_copy.get('numa_quest_complete') and state_copy.get('ks_at_commons'):
		$wait_oliver2.name = 'wait_oliver'
		$wait_numa2.name = 'wait_numa'
		$poof_sinners2.name = 'poof_sinners'
	elif state_copy.get('numa_quest_complete') and not state_copy.get('ks_at_commons'):
		$wait_oliver2.name = 'wait_oliver'
		$wait_numa2.name = 'wait_numa'
		$poof_sinners3.name = 'poof_sinners'
	else:
		$wait_oliver1.name = 'wait_oliver'
		$wait_numa1.name = 'wait_numa'
		$poof_sinners1.name = 'poof_sinners'
	
	$wait_commons_door.set_highlight_on_hover(true)
	$wait_exit2.set_highlight_on_hover(true)
	
func play_default_music(state):
	if state.get('on_hold'):
		emit_signal('change_audio', 'Fly_Me_To_The_Meow')
	elif state.get('called_lucifur'):
		emit_signal('change_audio', 'Lucifur')
	else:			
		emit_signal('change_audio', default_music)
		
func init_state(state):
	.init_state(state)
	
	if state.get('drama_ongoing'):
		emit_signal('start_dialog', 'drama_start', [$kyungsoon_idle])
		
	if state.get('oliver_hears_numa'):
		$oliver_huh.show()
		state['oliver_hears_numa'] = false
	else:
		$oliver_huh.hide()
		
	if state.get('commons_flowers'):
		$flowers_etc.show()
	else:
		$flowers_etc.hide()
		
	if state.get('oliver_goto_commons'):
		state['oliver_goto_commons'] = false
		if state.get('numa_at_commons'):
			emit_signal('set_hidden_sprite', [$kyungsoon_idle, $numa_at_commons])
		else:
			emit_signal('set_hidden_sprite', [$kyungsoon_idle])
	
	if state.get('flashback_goto_commons'):
		state['flashback_goto_commons'] = false
		if state.get('numa_at_commons'):
			emit_signal('set_hidden_sprite', [$kyungsoon_idle, $numa_at_commons])
		else:
			emit_signal('set_hidden_sprite', [$kyungsoon_idle])
	
	# ks should be at the commons by default, if it's never been set before
	if not state.has('ks_at_commons'):
		state['ks_at_commons'] = true
	
	# if you talked to them at the commons, the NEXT time you enter the commons, they should be gone
	if state.get('ks_and_numa_commons_done') and\
		(state.get('ks_at_commons') or state.get('numa_at_commons')):
		state['ks_at_commons'] = false
		state['numa_at_commons'] = false
	
func update_state(state):
	.update_state(state)
		
	if state.get('display_kyungsoon_and_numa'):
		state['display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [$kyungsoon_idle, $numa_at_commons])
	
	if state.get('dont_display_kyungsoon_and_numa'):
		state['dont_display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [])

	if state.get('ks_goto_vents'):
		emit_signal('change_room', 'hallway6')
		state['ks_goto_vents'] = false
		
	if state.get('numa_at_commons'):
		$numa_at_commons.show()
		$cat1_idle.hide()
	else:
		$numa_at_commons.hide()
		$cat1_idle.show()
		
	if state.get('ks_at_commons'):
		$kyungsoon_idle.show()
	else:
		$kyungsoon_idle.hide()
		
	if state.get('unlocked_commons_door'):
		$commons_door_exit.show()
		$commons_door_dialog.hide()
	else:
		$commons_door_exit.hide()
		$commons_door_dialog.show()
	
	if state.get('blackout'):
		$phone.hide()
		$phone_blackout.show()
	else:
		$phone.show()
		$phone_blackout.hide()
	
	# lucifur and stuff
	
	if state.get('lucifur_appears'):
		state['no_cat'] = true
		state['lucifur_in_commons'] = true
		$lucifur/AnimationPlayer.play('lucifur_poof')
		$poof_cover.show()
		anim_playing = true
	
	if state.get('lucifur_snaps'):
		$poof_sinners/AnimationPlayer.play('poof')
		$poof_cover.show()
		anim_playing = true
		
	if state.get('lucifur_frog'):
		$frog/AnimationPlayer.play('lucifur_poof')
		$poof_cover.show()
		anim_playing = true
		
	if state.get('no_cat'):
		$cat1_idle.hide()
	else:
		$cat1_idle.show()
		
	if state.get('frog_in_commons'):
		$frog.show()
		$commons_lamp.hide()
	else:
		$frog.hide()
		$commons_lamp.show()
		
	if state.get('lucifur_in_commons'):
		$lucifur.show()
	else:
		$lucifur.hide()
		
	if state.get('poofing'):
		# things that are also handled elsewhere -- we're just overriding it
		$numa_at_commons.hide()
		$kyungsoon_idle.hide()
		$oliver_huh.hide()
		
	if state.get('waiting'):
		# things that are also handled elsewhere -- we're just overriding it
		$numa_at_commons.hide()
		$kyungsoon_idle.hide()
		$oliver_huh.hide()
		$commons_door_exit.hide()
		$commons_door_dialog.hide()
		
		# things that are only handled here
		$exit2.hide()
		$wait_exit2.show()
		$wait_commons_door.show()
		$wait_elijah.show()
		$wait_kyungsoon.show()
		$wait_natalie.show()
		$wait_numa.show()
		$wait_oliver.show()
		$wait_sean.show()
		$wait_tori.show()
	else:
		$exit2.show()
		$wait_exit2.hide()
		$wait_commons_door.hide()
		$wait_elijah.hide()
		$wait_kyungsoon.hide()
		$wait_natalie.hide()
		$wait_numa.hide()
		$wait_oliver.hide()
		$wait_sean.hide()
		$wait_tori.hide()
	
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
	
	if state.get('commons_flip_coin'):
		state['commons_flip_coin'] = false
		$coin/AnimationPlayer.play('paraola')
		
	if state.get('empty_commons'):
		$numa_at_commons.hide()
		$kyungsoon_idle.hide()
		$oliver_huh.hide()

func animation_finished(anim_name):
	anim_playing = false
	
func _on_poof_cover_pressed():
	print('boooop')
	if not anim_playing:
		$poof_cover.hide()
		
		if state_copy.get('lucifur_appears'):
			state_copy['lucifur_appears'] = false
			emit_signal('start_dialog', 'lucifur_intro', [])
			
		elif state_copy.get('lucifur_snaps'):
			state_copy['lucifur_snaps'] = false
			$poof_sinners.hide()
			emit_signal('start_dialog', 'lucifur_gathering', [])
			
		elif state_copy.get('lucifur_frog'):
			state_copy['lucifur_frog'] = false
			emit_signal('start_dialog', 'lucifur_gathering1', [])

