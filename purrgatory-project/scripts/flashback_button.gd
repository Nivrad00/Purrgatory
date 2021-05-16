extends Button

func _ready():
	set_default_cursor_shape(Control.CURSOR_POINTING_HAND)

func highlight_text(on):
	if on:
		get_parent().modulate = Color(0.75, 0.75, 0.75, get_parent().modulate.a)
	else:
		get_parent().modulate = Color(1, 1, 1, get_parent().modulate.a)
		
func show_custom():
	var mouse = get_global_mouse_position()
	var rect = get_rect()
	highlight_text(get_rect().has_point(mouse))
	get_parent().show()