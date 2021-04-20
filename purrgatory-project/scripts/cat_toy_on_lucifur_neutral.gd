extends Sprite

func _ready():
	if get_tree().get_root().get_node('main/game').state.get('gave_cat_toy'):
		show()
	else:
		hide()