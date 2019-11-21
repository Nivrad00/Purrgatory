extends Control

var to_draw = []

func _on_draw():
	if to_draw.size() > 0:
		var line = to_draw.pop_front()
		draw_line(line[0], line[1], Color(0, 0, 0), 1, false)
	
func _process(delta):
	update()