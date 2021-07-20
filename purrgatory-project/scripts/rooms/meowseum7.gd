extends 'state_handler_template.gd'

func _ready():
	$exit2_dialog.highlight_on_hover = true
	
func update_state(state):
	.update_state(state)
	if state.get('_inv_snowglobe_meowseum') or state.get('placed_snowglobes'):
		$snowglobe_meowseum.hide()
	
	$exit2.hide()
	$exit2_dialog.hide()
	if state.get('sean_went_to_piano'):
		$exit2.show()
	else:
		$exit2_dialog.show()
		
	if state.get('smash_sfx'):
		$smash.play()
		state['smash_sfx'] = false
		emit_signal('change_audio', null)
