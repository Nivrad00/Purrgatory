extends PolygonButton

export var room_label = ''

signal change_room(label)

func _ready():
	.set_highlight_on_hover(true)
	connect("pressed", self, "on_pressed")

func on_pressed():
	print(room_label)
	emit_signal('change_room', room_label)
	# this signal needs to be connected to the root node of the room (room_instance.gd)