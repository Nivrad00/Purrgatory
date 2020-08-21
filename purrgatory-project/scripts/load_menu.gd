extends Control

signal load_file(file)
signal deleted_data()

func load_save_files():
	var f = File.new()
	for i in range(0, 6):
		
		if f.file_exists('user://thumb' + str(i) + '.png'):
			var image = Image.new()
			image.load('user://thumb' + str(i) + '.png')
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			get_node("files/file" + str(i)).set_button_icon(texture)
			get_node("files/file" + str(i)).mouse_default_cursor_shape = Input.CURSOR_POINTING_HAND
		else:
			get_node("files/file" + str(i)).set_button_icon(null)
			get_node("files/file" + str(i)).mouse_default_cursor_shape = Input.CURSOR_ARROW
		
		if f.file_exists('user://save' + str(i) + '.save'):
			f.open("user://save" + str(i) + ".save", File.READ)
			var save_dict = parse_json(f.get_line())
			f.close()
			
			var timestamp = save_dict["timestamp"]
			var name = save_dict["format_dict"].get("player", "")
			if name.length() > 16:
				name = name.substr(0, 13) + "..."
			get_node("dates/date" + str(i)).set_text(timestamp + "\r\n" + name)
		else:
			get_node("dates/date" + str(i)).set_text("")
			
			
	
func load_file(file):
	var save_game = File.new()
	if not save_game.file_exists("user://save" + str(file) + ".save"):
		return
	emit_signal('load_file', file)

func show_custom():
	load_save_files()
	show()

func delete_data():
	var dir = Directory.new()
	for i in range(0, 6):
		dir.remove("user://save" + str(i) + ".save")
		dir.remove("user://thumb" + str(i) + ".png")
		dir.remove("user://seen_blocks" + str(i) + ".save")
		dir.remove("user://mural" + str(i) + ".png")
	
	yield(get_tree(), "idle_frame")
	load_save_files()

	emit_signal('deleted_data')
