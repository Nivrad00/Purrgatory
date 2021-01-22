extends 'state_handler_template.gd'

onready var state_copy = get_node('../../../../..').state

func init_state(state):
	if state.get('tori_train_complete'):
		state['ks_and_numa_train_override'] = false
	
func update_state(state):
	.update_state(state)
	
	$ks_and_numa.hide()
	$ks_and_numa2.hide()
	$ks_and_numa3.hide()
	$bg.hide()
	$bg2.hide()
	$vending_machine1.hide()
	$vending_machine2.hide()
	$train_tracks1.hide()
	$train_tracks2.hide()
	$train_columns1.hide()
	$train_columns2.hide()
	$junk_food.hide()
	
	if state.get('tori_train_complete'):
		$tori_idle.hide()
	else:
		if state.get('natalie_completed_mural') and not state.get('natalie_working_on_nocturnal'):
			$tori_idle.hide()
		else:
			$tori_idle.show()
		state['ks_and_numa_train_override'] = true
	
	if state.get('ks_and_numa_train_override'):
		$bg.show()
		$vending_machine1.show()
		$train_tracks1.show()
		$train_columns1.show()
		return # tori supercedes ks and numa
	
	if state.get('ks_and_numa_at_train') and state.get('broke_vending_machine'):
		$ks_and_numa3.show()
		$bg2.show()
		$vending_machine2.show()
		$train_tracks2.show()
		$train_columns2.show()
		$junk_food.show()
	elif state.get('ks_and_numa_at_train') and state.get('breaking_vending_machine'):
		$ks_and_numa2.show()
		$bg2.show()
		$vending_machine2.show()
		$train_tracks2.show()
		$train_columns2.show()
		$junk_food.hide()
	elif state.get('ks_and_numa_at_train'):
		$ks_and_numa.show()
		$bg.show()
		$vending_machine1.show()
		$train_tracks1.show()
		$train_columns1.show()
	else:
		$bg.show()
		$vending_machine1.show()
		$train_tracks1.show()
		$train_columns1.show()
	
	if state.get('dont_display_kyungsoon_and_numa'):
		state['dont_display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [])
		
	if state.get('vending_machine_flag1'):
		emit_signal('change_audio', '')
		state['vending_machine_flag1'] = false
		$white.show()
		$white/AnimationPlayer.play('fadein')
		$smash/a.play()
		
	if state.get('vending_machine_flag2'):
		state['vending_machine_flag2'] = false
		$smash/b.play()
		
	if state.get('vending_machine_flag3'):
		state['vending_machine_flag3'] = false
		$smash/c.play()
		
	if state.get('vending_machine_flag4'):
		$white/AnimationPlayer.play('fadeout')
		yield($white/AnimationPlayer, "animation_finished")
		$white.hide()
		$click.show()

func _on_click_pressed():
	state_copy['vending_machine_flag4'] = false
	$click.hide()
	emit_signal('start_dialog', 'ks_and_numa_train2', [$ks_and_numa])
	emit_signal('change_audio', default_music)
