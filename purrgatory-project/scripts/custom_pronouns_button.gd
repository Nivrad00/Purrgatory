extends CheckBox

# this is (non-DRYly) stolen from TranslatedNode
func _ready():
	update_label(Language.language)
	
	if not Language.is_connected("language_changed", self, "update_label"):
		Language.connect("language_changed", self, "update_label")

func update_label(lang):
	if lang in [0, 1, 6]:
		show()
		$"../custom2".show()
		
		$"../polish_gender_x".hide()
		$"../polish_gender_x2".hide()
		
		if $"../polish_gender_x".pressed:
			$"../they".pressed = true
			
	elif lang == 4:
		hide()
		$"../custom2".hide()
		
		$"../polish_gender_x".show()
		$"../polish_gender_x2".show()
			
		if pressed:
			$"../they".pressed = true
			
	else:
		hide()
		$"../custom2".hide()
		
		$"../polish_gender_x".hide()
		$"../polish_gender_x2".hide()
		
		if pressed or $"../polish_gender_x".pressed:
			$"../they".pressed = true
		
func _on_custom_pressed():
	$"../../custom_pronouns".show()
		
