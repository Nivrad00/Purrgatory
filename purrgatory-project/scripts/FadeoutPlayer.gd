extends AudioStreamPlayer

var fade = false

func fadeout():
	fade = true

func _process(delta):
	if fade:
		if volume_db == -80:
			stop()
			queue_free()
		else:
			volume_db = max(-80, volume_db - delta * 200)
