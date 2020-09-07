extends Control

var enabled = true
var sens = 0.4
var prev_pos = Vector2(600, 500)

var min_x = 325
var max_x = 958
var min_y = 170
var max_y = 543

func _ready():
	$draw_texture.set_texture($draw_viewport.get_texture())
	
	var state = get_node('../../../../../../..').state
	if state.get('draw_a_paw_x') and state.get('draw_a_paw_y'):
		prev_pos = Vector2(state['draw_a_paw_x'], state['draw_a_paw_y'])
		
	$tip.rect_position = prev_pos + Vector2(-2, -2)
	
func disable():
	prev_pos = null
	enabled = false

func enable():
	enabled = true
	
func _process(delta):
	update()

func _on_left_knob_rotated(amount):
	knob_rotated(Vector2(-amount, 0))

func _on_right_knob_rotated(amount):
	knob_rotated(Vector2(0, amount))

func knob_rotated(vec):
	if not enabled:
		return
		
	var current_pos = prev_pos - sens * vec
	current_pos.x = clamp(current_pos.x, min_x, max_x)
	current_pos.y = clamp(current_pos.y, min_y, max_y)
	$draw_viewport/pen.to_draw.append([prev_pos, current_pos])
		
	prev_pos = current_pos
	$tip.rect_position = current_pos + Vector2(-2, -2)
	
