extends Control

var to_draw = []
var to_erase = false
	
func _on_draw():
	if to_draw.size() > 0:
		draw_line(to_draw[0][0], to_draw[to_draw.size()-1][1], Color(0, 0, 0), 1, false)
		to_draw = []
	
	if to_erase:
		to_erase = false
		draw_rect(Rect2(0, 0, 1280, 720), Color(1, 1, 1), true)
		
func _process(delta):
	update()
