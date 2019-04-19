extends TextureButton

export var dialog_label = ''
export var sprite_path = ''

signal start_dialog(label, sprite)

func _on_char_obj_button_pressed():
	if sprite_path == '':
		emit_signal('start_dialog', dialog_label, [self])
	else:
		emit_signal('start_dialog', dialog_label, [get_node(sprite_path)])
	# this signal will be connected to the root node of the room (room_instance.gd)