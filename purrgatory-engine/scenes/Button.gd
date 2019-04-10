extends Button

signal start_dialog(label)

func _on_Button_pressed():
	emit_signal('start_dialog', 'cool_text')
