extends 'state_handler_template.gd'

func _on_Button_pressed():
	emit_signal('start_dialog', 'oliver_can_help_meopw', [])
