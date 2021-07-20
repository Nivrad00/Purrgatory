extends PolygonButton

func _ready():
	$AnimationPlayer.advance(0)
	$Sprite3.hide()
	$Sprite5.hide()
	
func _on_frog_mouse_down():
	$audio.play()
