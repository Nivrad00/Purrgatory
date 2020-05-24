extends Control

signal save_file(file)
	
func load_save_files():
	var f = File.new()
	for i in range(0, 6):
		
		if f.file_exists('user://thumb' + str(i) + '.png'):
			var image = Image.new()
			image.load('user://thumb' + str(i) + '.png')
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			get_node("files/file" + str(i)).set_button_icon(texture)
		else:
			get_node("files/file" + str(i)).set_button_icon(null)
			
		if f.file_exists('user://save' + str(i) + '.save'):
			f.open("user://save" + str(i) + ".save", File.READ)
			var save_dict = parse_json(f.get_line())
			f.close()
			
			var timestamp = save_dict["timestamp"]
			var name = save_dict["format_dict"].get("player", "")
			if name.length() > 16:
				name = name.substr(0, 13) + "..."
			get_node("dates/date" + str(i)).set_text(timestamp + "\r\n" + name)


func save_file(file):
	emit_signal('save_file', file)

func show_custom():
	load_save_files()
	show()