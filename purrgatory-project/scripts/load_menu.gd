extends Control

signal load_file(file)

func load_save_files():
	var f = File.new()
	for i in range(0, 6):
		
		if f.file_exists('res://save_data/thumb' + str(i) + '.png'):
			var image = Image.new()
			image.load('res://save_data/thumb' + str(i) + '.png')
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			get_node("files/file" + str(i)).set_button_icon(texture)
		else:
			get_node("files/file" + str(i)).set_button_icon(null)
		
		if f.file_exists('res://save_data/save' + str(i) + '.save'):
			f.open("res://save_data/save" + str(i) + ".save", File.READ)
			var save_dict = parse_json(f.get_line())
			f.close()
			get_node("dates/date" + str(i)).set_text(save_dict["timestamp"])
			
	
func load_file(file):
	var save_game = File.new()
	if not save_game.file_exists("res://save_data/save" + str(file) + ".save"):
		return
	emit_signal('load_file', file)

func show_custom():
	load_save_files()
	show()