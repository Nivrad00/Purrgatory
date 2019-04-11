extends Button

export var dialog_label = ''

signal start_dialog(label)

func _on_char_obj_button_pressed():
	emit_signal('start_dialog', dialog_label)
	# this signal needs to be connected to the root node of the room (room_instance.gd)
