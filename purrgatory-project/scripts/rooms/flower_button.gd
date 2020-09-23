extends Control

signal pick_flower(id)
var id = -1
var texture_path = 'res://assets/sprites/flowers/'
var mask_path = 'res://assets/sprite_masks/flower_masks/'

func set_id(_id):
	id = _id
	var texture = load(texture_path + str(id) + '.png')
	$button.set_normal_texture(texture)
	$button.rect_position.y = -texture.get_height()
	
func _on_flower_pressed():
	emit_signal('pick_flower', id)
