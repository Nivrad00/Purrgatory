extends Control

onready var tts_node = get_node('../../tts_node')
onready var ui = get_node('../../content/ui')

func show_custom():
	show()

func hide_custom():
	ui.speak_ui()
	hide()
