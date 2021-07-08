extends Button

signal rotated(amount)

const AUTO_ROTATION = 400

var dragging = false
var left_pressed = false
var right_pressed = false

export var key_left = ""
export var key_right = ""

func _ready():
	set_process(true)
	
func _on_volume_button_down():
	dragging = true
	
func _on_volume_button_up():
	dragging = false

func _input(event):
	if dragging and event is InputEventMouseMotion:
		var old = rect_rotation
		
		var pivot = rect_position + rect_pivot_offset
		var current_pos = event.position - pivot
		var previous_pos = event.position - event.relative - pivot
		var movement = previous_pos.angle_to(current_pos)
		
		rect_rotation += rad2deg(movement)
		emit_signal("rotated", rect_rotation - old)
		
		if rect_rotation > 360:
			rect_rotation -= 360
		elif rect_rotation < 0:
			rect_rotation += 360
	
	if event is InputEventKey:
		if OS.get_scancode_string(event.scancode) == key_left:
			if event.pressed:
				left_pressed = true
			else:
				left_pressed = false
		if OS.get_scancode_string(event.scancode) == key_right:
			if event.pressed:
				right_pressed = true
			else:
				right_pressed = false

func _process(delta):
	if left_pressed and not right_pressed:
		# print(rect_rotation)
		var old = rect_rotation
		rect_rotation -= AUTO_ROTATION * delta
		emit_signal("rotated", rect_rotation - old)
		
		if rect_rotation > 360:
			rect_rotation -= 360
		elif rect_rotation < 0:
			rect_rotation += 360
		
	if right_pressed and not left_pressed:
		var old = rect_rotation
		rect_rotation += AUTO_ROTATION * delta
		emit_signal("rotated", rect_rotation - old)
		
		if rect_rotation > 360:
			rect_rotation -= 360
		elif rect_rotation < 0:
			rect_rotation += 360
