extends Button

export var room_label = ''

signal change_room(label)

func _on_room_trans_button_pressed():
	emit_signal('change_room', room_label)
	# this signal needs to be connected to the root node of the room (room_instance.gd)
