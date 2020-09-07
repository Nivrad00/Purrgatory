extends AnimatedSprite

func _on_Button_pressed():
	frame = (frame + 1) % 10
