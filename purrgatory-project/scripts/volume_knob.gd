extends Button

const SENS = 1

var dragging = false
	
func _on_volume_button_down():
	dragging = true
	
func _on_volume_button_up():
	dragging = false

func _input(event):
	if dragging and event is InputEventMouseMotion:
		var pivot = rect_position + rect_pivot_offset
		var current_pos = event.position - pivot
		var previous_pos = event.position - event.relative - pivot
		var movement = previous_pos.angle_to(current_pos)
		
		rect_rotation += rad2deg(movement)
		if rect_rotation > 360:
			rect_rotation = 360
		elif rect_rotation < 0:
			rect_rotation = 0
		
		get_parent().get_parent().update_volume(rect_rotation)