extends TextureButton

export var dialog_label = ''
export var sprite_path = []

signal start_dialog(label, sprite)
signal stop_all_hovering()

func _gui_input(event):
	if event is InputEventMouseMotion:
		emit_signal("stop_all_hovering")
	
func _on_char_obj_button_pressed():
	if sprite_path.size() == 0:
		emit_signal('start_dialog', dialog_label, [self])
	else:
		var sprites = []
		for path in sprite_path:
			if path == null: # a hack to say "don't send any sprites"
				continue
			sprites.append(get_node(path))
		emit_signal('start_dialog', dialog_label, sprites)
	# this signal will be connected to the root node of the room (room_instance.gd)

# this script/scene should now only be used for texture buttons (sprites), and not polygon buttons