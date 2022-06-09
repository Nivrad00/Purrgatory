extends Node
signal language_changed(n)

var language = 0

# this is accessed by settings
var languages = [
	'english', # 0
	'español (españa)' # 1
]

func set_language(n):
	language = n
	emit_signal("language_changed", n)
	print("language set to " + languages[n])



