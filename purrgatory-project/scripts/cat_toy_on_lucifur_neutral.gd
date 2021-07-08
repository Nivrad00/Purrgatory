extends Sprite

func _ready():
	var game = get_tree().get_root().get_node('main/game')
	if game and game.state.get('gave_cat_toy'):
		show()
	else:
		hide()
