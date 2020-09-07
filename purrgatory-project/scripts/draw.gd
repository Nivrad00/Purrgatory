extends Control

signal drew_line(start, end)

var enabled = false
var prev_mouse_pos = null

func _ready():
	$draw_texture.set_texture($draw_viewport.get_texture())
	
func disable():
	prev_mouse_pos = null
	enabled = false
	mouse_default_cursor_shape = Control.CURSOR_ARROW

func enable():
	enabled = true
	mouse_default_cursor_shape = Control.CURSOR_HELP

func _gui_input(input):
	if not enabled or not input is InputEventMouseMotion:
		return
	var current_mouse_pos = input.position
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and prev_mouse_pos:
		emit_signal('drew_line', prev_mouse_pos, current_mouse_pos)
		$draw_viewport/pen.to_draw.append([prev_mouse_pos, current_mouse_pos])
		
	prev_mouse_pos = current_mouse_pos
	
func _process(delta):
	update()
