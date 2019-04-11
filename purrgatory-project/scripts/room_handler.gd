extends Control

var room_path = 'res://scenes/room_scenes_scripts/'
var room_dict = {
	'antechamber1': preload('res://room_scenes_scripts/antechamber1.tscn'),
	'antechamber2': preload('res://room_scenes_scripts/antechamber2.tscn'),
	'antechamber3': preload('res://room_scenes_scripts/antechamber3.tscn'),
	'antechamber4': preload('res://room_scenes_scripts/antechamber4.tscn'),
	'antechamber5': preload('res://room_scenes_scripts/antechamber5.tscn'),
	'bell_tower': preload('res://room_scenes_scripts/bell_tower.tscn'),
	'commons1': preload('res://room_scenes_scripts/commons1.tscn'),
	'commons2': preload('res://room_scenes_scripts/commons2.tscn'),
	'library': preload('res://room_scenes_scripts/library.tscn')
}

func _ready():
	enable_all()
	
func disable_all():
	$room_mask.set_mouse_filter(Control.MOUSE_FILTER_STOP)

func enable_all():
	$room_mask.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

func change_room(label, state):
	for child in $room_container.get_children():
		child.queue_free()
	var new_room = room_dict[label].instance()
	new_room.connect('start_dialog', get_node("/root/game"), 'start_dialog')
	new_room.connect('change_room', get_node("/root/game"), 'change_room')
	$room_container.add_child(new_room)
	update_state(state)

func update_state(state):
	for child in $room_container.get_children():
		child.update_state(state)
	