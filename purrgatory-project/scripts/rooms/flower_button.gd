extends TextureButton

signal pick_flower(id)
var id = -1
var texture_path = 'res://assets/sprites/flowers/'
var mask_path = 'res://assets/sprite_masks/flower_masks/'

func set_id(_id):
	id = _id
	set_normal_texture(load(texture_path + str(id) + '.png'))
	set_click_mask(load(mask_path + str(id) + '.png'))
	
func _on_flower_pressed():
	emit_signal('pick_flower', id)
