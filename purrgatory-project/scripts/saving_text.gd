extends "TranslatedLabel.gd"

func update_label(lang):
	#.update_label(lang)
	if lang == 1:
		$AnimationPlayer.play("guardando...")
	elif lang == 0:
		$AnimationPlayer.play("saving..")