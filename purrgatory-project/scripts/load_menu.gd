extends Control

signal load_file(file)
signal deleted_data()
signal hiding()

func load_save_files():
	var f = File.new()
	for i in range(0, 6): # autosave (slot -1) has no image
		if f.file_exists('user://thumb' + str(i) + '.png'):
			var image = Image.new()
			image.load('user://thumb' + str(i) + '.png')
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			get_node("files/file" + str(i)).set_button_icon(texture)
		else:
			get_node("files/file" + str(i)).set_button_icon(null)
		
	for i in range(-1, 6):
		if f.file_exists('user://save' + str(i) + '.save'):
			f.open("user://save" + str(i) + ".save", File.READ)
			var save_dict = parse_json(f.get_line())
			f.close()
			
			var timestamp = save_dict["timestamp"]
			var name = save_dict["format_dict"].get("player", "")
			if name.length() > 16:
				name = name.substr(0, 13) + "..."
			
			if i == -1: # different formatting for autosave
				get_node("dates/date" + str(i)).set_text(timestamp + " - " + name)
			else:
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
	# disable autosave button if there is no autosave
	var f = File.new()
	if f.file_exists('user://save-1.save'):
		$load_autosave/x.hide()
	else:
		$load_autosave/x.show()
	# ...we don't actually have to disable it since it's already set to do nothing if the file
	#    doesn't exist; we just have to indicate that it's disabled
	show()

func delete_data():
	var dir = Directory.new()
	for i in range(-1, 6):
		dir.remove("user://save" + str(i) + ".save")
		dir.remove("user://thumb" + str(i) + ".png")
		dir.remove("user://seen_blocks.save")
		dir.remove("user://mural" + str(i) + ".png")
		dir.remove("user://ttt_state" + str(i) + ".save")
		dir.remove("user://ttt_drawing" + str(i) + ".png")
		dir.remove("user://draw_a_paw" + str(i) + ".png")
	
	yield(get_tree(), "idle_frame")
	load_save_files()

	emit_signal('deleted_data')
	
	show_custom()
	
	
func hide_custom():
	hide()
	emit_signal('hiding')
