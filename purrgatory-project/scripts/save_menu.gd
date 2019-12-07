extends Control

signal save_file(file)
	
func load_save_files():
	pass # this is where it'll load the preview images

func save_file(file):
	emit_signal('save_file', file)

func show_custom():
	load_save_files()
	show()
