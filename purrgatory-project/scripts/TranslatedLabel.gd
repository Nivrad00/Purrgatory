# this is an old script from when i implemented translations from scratch and like
#   manually copy-pasted every translation into every ui element
# which is stupid of course
# we are using the built-in translation system now so we should never need this script

extends Control

export var translations = [""] # not including english

func _ready():
	# this ensures it doesn't keep adding to the array every time it's initialized... bc for some
	# reason it remembers what the array was even after being deleted...
	if translations.size() == Language.languages.size():
		pass
		
	elif translations.size() == Language.languages.size() - 1:
		# add the english version to the start of the array
		if "bbcode_text" in self:
			translations.push_front(get("bbcode_text"))
		elif "text" in self:
			translations.push_front(get("text"))
	
	else:
		if get_parent().get_parent() != null:
			print("error: wrong number of translations for node ..." + get_parent().get_parent().name + "."  + get_parent().name + "." + name)
		elif get_parent() != null:
			print("error: wrong number of translations for node ..." + get_parent().name + "." + name)
		else:
			print("error: wrong number of translations for node ..." + name)
		# still add the english version to the start of the array lol
		if "bbcode_text" in self:
			translations.push_front(get("bbcode_text"))
		elif "text" in self:
			translations.push_front(get("text"))
	
		
	update_label(Language.language)
	
	if not Language.is_connected("language_changed", self, "update_label"):
		Language.connect("language_changed", self, "update_label")

func update_label(lang):
	if lang >= translations.size():
		lang = 0 
		# default to english if the translation id is out of bounds
		# (aka if i haven't gotten around to translating the node yet)
		
	if "bbcode_text" in self and translations.size() > lang:
		set("bbcode_text", translations[lang].c_unescape())
	elif "text" in self and translations.size() > lang:
		set("text", translations[lang].c_unescape())
