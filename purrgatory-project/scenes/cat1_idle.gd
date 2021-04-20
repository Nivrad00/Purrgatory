extends 'res://scripts/char_obj_button.gd'

func _on_cat1_idle_button_down():
	if get_tree().get_root().get_node('main/game').state.get('_inv_cat_toy'):
		emit_signal('start_dialog', 'give_cat_toy', [])
	else:
		print('uh')
		$audio.play()
