extends Node

func _ready():
	update_label(Language.language)
	
	if not Language.is_connected("language_changed", self, "update_label"):
		Language.connect("language_changed", self, "update_label")

func update_label(lang):
	for child in get_children():
		child.hide()
	if get_child(lang):
		get_child(lang).show()
	else:
		print("error: no translation found for node " + name)
