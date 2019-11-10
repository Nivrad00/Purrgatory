extends Control

signal drew_line(start, end)

func _ready():
	$draw_texture.set_texture($draw_viewport.get_texture())
	
func disable():
	$draw_viewport/pen.prev_mouse_pos = null
	$draw_viewport/pen.enabled = false

func enable():
	$draw_viewport/pen.enabled = true

func _on_pen_drew_line(start, end):
	emit_signal('drew_line', start, end)
