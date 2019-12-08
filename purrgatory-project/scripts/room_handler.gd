extends Control

var room_path = 'res://scenes/rooms/'
var loader
var loading_path
var loading_state

var current_room = null
onready var game = get_node("../..")

func get_current_room():
	return current_room.get_name()

func get_hidden_sprites():
	var sprite_names = []
	var sprites = current_room.hidden_sprites
	if sprites == null:
		return null
	for sprite in sprites:
		sprite_names.append(sprite.name)
	return sprite_names
	
func set_hidden_sprites(sprite_names):
	if sprite_names == null:
		current_room.hidden_sprites = null
		return
	var sprites = []
	for sprite_name in sprite_names:
		var sprite = current_room.get_node('state_handler').get_node(sprite_name)
		sprites.append(sprite)
	current_room.hidden_sprites = sprites
	
func start_dialog():
	$room_mask.set_mouse_filter(Control.MOUSE_FILTER_STOP)

func end_dialog():
	for child in $room_container.get_children():
		child.end_dialog()
	$room_mask.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

func change_room(label, state, music = true):
	var new_room = load(room_path + label + '.tscn')
	if new_room == null:
		game.start_dialog("room_placeholder")
		return
	new_room = new_room.instance()
	current_room = new_room
	
	new_room.connect('start_dialog', game, 'start_dialog')
	new_room.connect('change_room', game, 'change_room')
	new_room.connect('start_action_timer', game, 'start_action_timer')
	new_room.connect('change_audio', game, 'change_audio')
	
	for child in $room_container.get_children():
		child.queue_free()
		yield(get_tree(), 'idle_frame')
	$room_container.add_child(new_room)
	new_room.set_name(label)
	
	if music:
		current_room.play_default_music()
	current_room.init_state(state)
	current_room.update_state(state)

func update_state(state):
	for child in $room_container.get_children():
		child.update_state(state)