extends PolygonButton

export var dialog_label = ''
export var sprite_path = []

signal start_dialog(label, sprite)

func _ready():
	connect("pressed", self, "on_pressed")
	
func on_pressed():
	if sprite_path.size() == 0:
		emit_signal('start_dialog', dialog_label.strip_edges(), [self])
	else:
		var sprites = []
		for path in sprite_path:
			if path == null: # a hack to say "don't send any sprites"
				continue
			sprites.append(get_node(path))
		emit_signal('start_dialog', dialog_label.strip_edges(), sprites)
	# this signal will be connected to the root node of the room (room_instance.gd)
