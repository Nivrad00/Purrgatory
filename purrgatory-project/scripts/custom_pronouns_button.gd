extends CheckBox

func _on_custom_pressed():
	# so far, all language except polish have three pronoun options and a customization option
	# polish just has four pronoun options, including two neutral ones
	if Language.language != 4: 
		$"../../custom_pronouns".show()
		
