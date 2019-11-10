extends Control

signal drew_line(start, end)

var enabled = false
var prev_mouse_pos = null
var black = Color(0, 0, 0)

func _ready():
	pass

func _on_draw():
	if not enabled:
		return
	var current_mouse_pos = get_local_mouse_position()
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and prev_mouse_pos:
		draw_line(prev_mouse_pos, current_mouse_pos, black, 1, false)
		emit_signal('drew_line', prev_mouse_pos, current_mouse_pos)
		
	prev_mouse_pos = current_mouse_pos
	
func _process(delta):
	update()