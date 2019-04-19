extends Sprite

var texture_path = 'res://assets/sprites/flowers/'

func set_indicator(id):
	$flower_indicator.set_texture(load(texture_path + str(id) + '.png'))