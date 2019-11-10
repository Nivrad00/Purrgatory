extends Control

var i = 1
var texture = load('res://assets/ui/flower_progress1.png')

func increment():
	get_node(str(i)).set_texture(texture)
	i += 1