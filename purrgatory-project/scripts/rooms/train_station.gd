extends 'state_handler_template.gd'

onready var state_copy = get_node('../../../../..').state

func init_state(state):
	if state.get('tori_train_complete'):
		state['ks_and_numa_train_override'] = false
	
func update_state(state):
	.update_state(state)
		
	$ks_and_numa.hide()
	
	if state.get('tori_train_complete'):
		$tori_idle.hide()
	else:
		$tori_idle.show()
		state['ks_and_numa_train_override'] = true
	
	if state.get('ks_and_numa_train_override'):
		return # tori supercedes ks and numa
		
	if state.get('ks_and_numa_at_train'):
		$ks_and_numa.show()
		
	if state.get('dont_display_kyungsoon_and_numa'):
		state['dont_display_kyungsoon_and_numa'] = false
		emit_signal('set_hidden_sprite', [])
		
	if state.get('vending_machine_flag1'):
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
