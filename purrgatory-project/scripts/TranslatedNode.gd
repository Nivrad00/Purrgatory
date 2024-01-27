extends Node

func _ready():
	update_label(Language.language)
	
	if not Language.is_connected("language_changed", self, "update_label"):
		Language.connect("language_changed", self, "update_label")

func update_label(lang):
	for child in get_children():
		child.hide()
	if lang < get_child_count():
		get_child(lang).show()
	else:
		print("error: no translation found for node " + name)
		get_child(0).show()
		# default to english if the translation id is out of bounds
		# (aka if i haven't gotten around to translating the node yet)
