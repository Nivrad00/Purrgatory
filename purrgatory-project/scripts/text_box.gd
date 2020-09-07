extends Button

func _ready():
	set_process(true)
	
func _process(delta):
	if disabled:
		mouse_default_cursor_shape = Input.CURSOR_ARROW
	else:
		mouse_default_cursor_shape = Input.CURSOR_ARROW
