# this is an old script from when i implemented translations from scratch and like
#   manually copy-pasted every translation into every ui element
# which is stupid of course
# we are using the built-in translation system now so we should ONLY SOMTIMES need this script
# namely, when we need an entirely separate node for each language, like with the custom pronouns menu

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
