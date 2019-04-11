extends Node2D

var sprites_path = 'res://assets/sprites/'
			
func set_sprite(name):
	$image.set_texture(load(sprites_path + name + '.png'))