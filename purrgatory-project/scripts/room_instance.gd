extends Control

signal start_dialog(label)
signal change_room(label)

func update_state(state):
	$state_handler.update_state(state)
	
func _on_char_obj_button_start_dialog(label):
	emit_signal('start_dialog', label)

func _on_room_trans_button_change_room(label):
	emit_signal('change_room', label)