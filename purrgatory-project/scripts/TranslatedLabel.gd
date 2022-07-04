extends Control

export var translations = [""] # not including english

func _ready():
	# this ensures it doesn't keep adding to the array every time it's initialized... bc for some
	# reason it remembers what the array was even after being deleted...
	if translations.size() == Language.languages.size():
		pass
		
	elif translations.size() == Language.languages.size() - 1:
		if "bbcode_text" in self:
			translations.push_front(get("bbcode_text"))
		elif "text" in self:
			translations.push_front(get("text"))
	
	else:
		print("error: wrong number of translations for node " + name)
		
	update_label(Language.language)
	
	if not Language.is_connected("language_changed", self, "update_label"):
		Language.connect("language_changed", self, "update_label")

func update_label(lang):
	if "bbcode_text" in self and translations.size() > lang:
		set("bbcode_text", translations[lang].c_unescape())
	elif "text" in self and translations.size() > lang:
		set("text", translations[lang].c_unescape())
