extends Node2D

var current_keys = []
var last_key = null

func _ready():
	set_process(true)
	
	for child in get_children() + get_node('../keyboard_handler2').get_children():
		child.connect("key_up", self, "key_up")
		child.connect("key_down", self, "key_down")

func key_down(key):
	if key in current_keys:
		return
		
	if key.type == 'white':
		if current_keys.size() == 0:
			key.on_key_down()
		current_keys.push_back(key)
		
	elif key.type == 'black':
		if current_keys.size() > 0:
			current_keys[0].on_key_up()
		key.on_key_down()
		current_keys.push_front(key)

func key_up(key):
	if not key in current_keys:
		return
		
	if current_keys[0] == key:
		key.on_key_up()
		if current_keys.size() > 1:
			current_keys[1].on_key_down()
	current_keys.erase(key)

func _process(delta):
	if current_keys.size() == 0:
		last_key = null
	elif current_keys[0] != last_key:
		current_keys[0].play_note()
		last_key = current_keys[0]
