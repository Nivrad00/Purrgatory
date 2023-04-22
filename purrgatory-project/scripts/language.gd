extends Node
signal language_changed(n)

var language = 0
var fonts = [
	load("res://themes/dialog_font.tres"),
	load("res://themes/ui_font_18.tres"),
	load("res://themes/ui_font_21.tres"),
	load("res://themes/ui_font_24.tres"),
	load("res://themes/ui_font_40.tres")
]
	
# this is accessed by settings
var languages = [
	'english', # 0
	'español (españa)', # 1
	'(placeholder) simplified chinese' # 3
]

func set_language(n):
	language = n
	emit_signal("language_changed", n)
	print("language set to " + languages[n])

	# setting chinese font here cus idk where else to do it
	if n == 2:
		for font in fonts:
			font.font_data = preload("res://assets/fonts/NotoSansSC-Light.otf")
			load("res://themes/dialog_font_italics.tres").font_data = preload("res://assets/fonts/NotoSansSC-Bold.otf")
	else:
		for font in fonts:
			font.font_data = preload("res://assets/fonts/Krub-ExtraLight.ttf")
			load("res://themes/dialog_font_italics.tres").font_data = preload("res://assets/fonts/Krub-ExtraLightItalic.ttf")
