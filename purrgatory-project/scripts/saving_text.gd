extends "TranslatedLabel.gd"

func update_label(lang):
	#.update_label(lang)
	if lang == 1:
		print("playing g")
		$AnimationPlayer.play("guardando...")
	elif lang == 0:
		print("playing s")
		$AnimationPlayer.play("saving..")