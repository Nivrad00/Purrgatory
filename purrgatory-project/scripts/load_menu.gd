extends Control

signal load_file(file)

func load_save_files():
	pass # this is where it'll load the preview images

func load_file(file):
	var save_game = File.new()
	if not save_game.file_exists("user://save" + str(file) + ".save"):
		return
	emit_signal('load_file', file)

func show_custom():
	load_save_files()
	show()