extends Button

func _on_mouse_entered():
	$text.modulate.a = 0.5

func _on_mouse_exited():
	$text.modulate.a = 1
