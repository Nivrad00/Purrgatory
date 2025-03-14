extends Node
signal language_changed(n)

var language = 0
var fonts = [
	load("res://themes/dialog_font.tres"),
	load("res://themes/ui_font_18_scalable.tres"),
	load("res://themes/ui_font_18.tres"),
	load("res://themes/ui_font_21.tres"),
	load("res://themes/ui_font_24.tres"),
	load("res://themes/ui_font_40.tres")
]
	
# this is accessed by settings
var languages = [
	'english', # 0
	'español (españa)', # 1
	'简体中文', # 2
	'italiano', # 3
	'polski', # 4
	'português (brasil)', # 5
	'español (latinoamérica)' # 6
]

# this is for communicating with godot's built-in translation server
var locales = [
	'en', # 0
	'es', # 1
	'zh', # 2
	'it', # 3
	'pl', # 4
	'pt', # 5
	'es_SV' # 6... there's no code for "latin american spanish" in this version so i'm using el salvador as a stand-in
]

func set_language(n):
	language = n
	TranslationServer.set_locale(locales[language])
	
	# below is how i used to switch between translations, back when all the translation was manual
	# now we are using godot's built-in translation system so this only handles a few edge cases
	# such as setting the language displayed in the main menu dropdown when the game loads 
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
	
	# also, squish some of the text if the polish translation won't fit
	if n == 4:
		load("res://themes/ui_font_18_scalable.tres").size = 14
	else:
		load("res://themes/ui_font_18_scalable.tres").size = 18
		
	# note: the chinese font (Noto Sans) is already a fallback for the default latin font (Source Sans Pro, though the file says Krub)
	# this is so that if you enter text somewhere in CJK then switch to a non-CJK language, it'll still be displayed
	# the reason we manually switch it is only because the angled quotes in english and chinese share the same codepoint, but need to be
	#     displayed differently
	# so they would be displayed wrong using the "Source Sans Pro with Noto Sans as a fallback" system

# a note on fonts:

# dialog_font / dialog_font_italics
#    used for large quantities of text, namely the dialog, 
#    flashbacks, and main menu credits. can be rescaled in settings, and switches between
#    latin and chinese fonts as needed
# chinese_only_dialog_font
#    used wherever text needs to be scalable, but always stay in chinese. namely, the 
#    main menu credits

# ui_font_18_scalable
#    only used for buttons where the polish text doesn't fit
#    switches between a smaller size for polish and size 18 for every other language
#    also switches between latin and chinese fonts as needed
# ui_font_18 / ui_font_21 / ui_font_24 / ui_font_40
#    used wherever text needs to be a static size, typically UI elements. switches 
#    between latin and chinese fonts as needed
# chinese_only_font / chinese_only_font_21
#    used wherever text needs to be a static size, but always stay in chinese. namely, the
#    language dropdown menus and chinese names in the endgame credits
# english_only_font
#    ditto, but with latin characters. this is only used for the sfx page on the
#    end credits cus if it gets turned into the chinese font then it gets too big

# button_placeholder_font
#    i think this is a 0-size font used solely to make some buttons in the UI smaller?


