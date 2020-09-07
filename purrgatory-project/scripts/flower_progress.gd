extends Control

var i = 1
var texture = load('res://assets/ui/flower_progress1.png')

func increment():
	if get_node(str(i)):
		get_node(str(i)).set_texture(texture)
		i += 1
