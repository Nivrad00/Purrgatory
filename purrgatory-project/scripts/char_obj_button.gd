extends TextureButton

export var dialog_label = ''

signal start_dialog(label, sprite)

func _on_char_obj_button_pressed():
	print('asd')
	emit_signal('start_dialog', dialog_label, self)
	# this signal will be connected to the root node of the room (room_instance.gd)