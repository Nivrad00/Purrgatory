extends Control

var room_path = 'res://scenes/rooms/'
	
func start_dialog():
	$room_mask.set_mouse_filter(Control.MOUSE_FILTER_STOP)

func end_dialog():
	for child in $room_container.get_children():
		child.end_dialog()
	$room_mask.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

func change_room(label, state):
	var new_room = load(room_path + label + '.tscn')
	if new_room == null:
		get_parent().start_dialog("room_placeholder")
		return
	new_room = new_room.instance()
	
	new_room.connect('start_dialog', get_parent(), 'start_dialog')
	new_room.connect('change_room', get_parent(), 'change_room')
	new_room.connect('start_action_timer', get_parent(), 'start_action_timer')
	
	for child in $room_container.get_children():
		child.queue_free()
	$room_container.add_child(new_room)
	
	new_room.init_state(state)
	new_room.update_state(state)

func update_state(state):
	for child in $room_container.get_children():
		child.update_state(state)
	