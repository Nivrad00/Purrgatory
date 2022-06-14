extends Button

func _ready():
	# connecting this by script instead of manually so i don't
	# have to do it on every flashback
	if not is_connected("pressed", get_parent(), "next"):
		connect("pressed", get_parent(), "next")
	
func _on_mouse_entered():
	$text.modulate.a = 0.5

func _on_mouse_exited():
	$text.modulate.a = 1

