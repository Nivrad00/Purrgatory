extends Control

var room_path = 'res://scenes/rooms/'
var loader
var loading_path
var loading_state

var current_room = null
var prev_room_label = null
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

func change_room(label, state, music = true, loading_file = false):
	if game.state.get('blackout'):
		if label == 'attic':
			game.get_node('content/dark_covers/attic').show()
			game.get_node('content/dark_covers/wire_game').hide()
			game.get_node('content/dark_covers/dark').hide()
		elif label == 'wire_game':
			game.get_node('content/dark_covers/attic').hide()
			game.get_node('content/dark_covers/wire_game').show()
			game.get_node('content/dark_covers/dark').hide()
		else:
			game.get_node('content/dark_covers/attic').hide()
			game.get_node('content/dark_covers/wire_game').hide()
			game.get_node('content/dark_covers/dark').show()
	else:
		game.get_node('content/dark_covers/attic').hide()
		game.get_node('content/dark_covers/wire_game').hide()
		game.get_node('content/dark_covers/dark').hide()
		
	# when loading a file, you don't call init_state. in all other situations, you do.
	if current_room:
		prev_room_label = current_room.get_name()
	
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
		current_room.play_default_music(game.state)
	if not loading_file:
		current_room.init_state(state)
	current_room.update_state(state)
		
	if label.substr(0, 10) == 'flashback_':
		game.get_node('negative_cover').show()
	else:
		game.get_node('negative_cover').hide()

func update_state(state, end = false):
	for child in $room_container.get_children():
		child.update_state(state, end)

# if a Control, such as a UI element or character sprite, is blocking the mouse
#   from hovering over a PolygonButton, we need to tell the PolygonButton that it's 
#   no longer being hovered over
# (i can't find a better way of doing it)

# this means that EVERY CONTROL that could ever block a PolygonButton needs to
#   call stop_all_hovering() when appropriate

# this includes:
#   TextureButton-derived sprites like characters and the cat (char_obj_button.gd calls stop_all_hovering())
#   menu, notes, items, and history buttons (each button is connected to stop_all_hovering() separately)
#   the UI itself (game.gd calls stop_all_hovering when a) dialog starts or b) the game loads with the ui visible)

func stop_all_hovering():
	if not current_room:
		return
	for node in current_room.get_node('state_handler').get_children():
		if node is PolygonButton:
			node.blocked = true
