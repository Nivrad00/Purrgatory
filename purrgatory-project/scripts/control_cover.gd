extends Button

var mouse_on = false
signal stop_all_hovering()

func _on_mouse_entered():
	#emit_signal("stop_all_hovering")
	mouse_on = true
	
func _on_mouse_exited():
	#emit_signal("start_all_hovering")
	mouse_on = false

func _on_visibility_changed():
	if not visible and mouse_on:
		#emit_signal("start_all_hovering")
		mouse_on = false
