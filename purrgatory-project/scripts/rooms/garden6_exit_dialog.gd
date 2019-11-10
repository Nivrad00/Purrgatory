extends TextureButton

export var dialog_label = ''

signal start_dialog(label, sprite)

func _on_char_obj_button_pressed():
	emit_signal('start_dialog', dialog_label, [get_node('../numa')])
	
func _on_exit_dialog_mouse_entered():
	set_modulate(Color(0, 0, 0, 0.1))

func _on_exit_dialog_mouse_exited():
	set_modulate(Color(0, 0, 0, 0))
