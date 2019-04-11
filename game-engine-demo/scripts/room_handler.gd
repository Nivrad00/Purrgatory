extends Control

var room_path = 'res://scenes/rooms/'

func _ready():
	enable_all()
	
func disable_all():
	$room_mask.set_mouse_filter(Control.MOUSE_FILTER_STOP)

func enable_all():
	$room_mask.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

func change_room(label, state):
	for child in $room_container.get_children():
		child.queue_free()
	var new_room = load(room_path + label + '.tscn').instance()
	new_room.connect('start_dialog', get_node("/root/game"), 'start_dialog')
	new_room.connect('change_room', get_node("/root/game"), 'change_room')
	$room_container.add_child(new_room)
	update_state(state)

func update_state(state):
	for child in $room_container.get_children():
		child.update_state(state)
	