extends TextureButton

export var room_label = ''

signal change_room(label)

func _on_room_trans_button_pressed():
	print(room_label)
	emit_signal('change_room', room_label)
	# this signal needs to be connected to the root node of the room (room_instance.gd)

func _on_room_trans_button_mouse_exited():
	set_modulate(Color(0, 0, 0, 0))

func _on_room_trans_button_mouse_entered():
	set_modulate(Color(0, 0, 0, 0.1))

# this script has been superceded by polygon_exit_button and shouldn't be used anywhere