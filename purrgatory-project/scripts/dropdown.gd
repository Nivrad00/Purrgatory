extends Control

signal examine_item(_name)

# max height is around 280 or so

onready var default_height = get_position().y
onready var notes_height = default_height + 250
onready var items_height = default_height + 120
var speed = 20

var move = false
var keep_x_constant = false # again, x as in exit

var items_shown = false
var notes_shown = false
var target_height = -1

onready var notes_button = get_node('../notes_button')
onready var items_button = get_node('../items_button')

var inv_sprite_path = 'res://assets/sprites/inv/'
var inv_button = preload('res://scenes/inv_button.tscn')

func _ready():
	set_process(true)

func hide_all():
	notes_button.set_modulate(Color(1, 1, 1))
	items_button.set_modulate(Color(1, 1, 1))
	target_height = default_height
	move = true
	
func toggle_notes():
	if notes_shown:
		notes_shown = false
		hide_all()
	else:
		if items_shown:
			items_shown = false
			items_button.set_modulate(Color(1, 1, 1))
		
		notes_shown = true
		notes_button.set_modulate(Color(0.9, 0.9, 0.9))
		target_height = notes_height
		move = true
	
func toggle_items():
	if items_shown:
		items_shown = false
		hide_all()
	else:
		if notes_shown:
			notes_shown = false
			notes_button.set_modulate(Color(1, 1, 1))
			keep_x_constant = true
			
		items_shown = true
		items_button.set_modulate(Color(0.9, 0.9, 0.9))
		target_height = items_height
		move = true

func _process(delta):
	if move:
		var pos = get_position()
		if target_height == -1 or target_height == pos.y:
			target_height == -1
			move = false
			keep_x_constant = false
		else:
			var target = Vector2(pos.x, target_height)
			set_position(pos + (target - pos)/2 * delta * speed)

func add_to_inv(_name):
	var texture = load(inv_sprite_path + _name + '.png')
	if texture == null:
		print('uh boss the inventory sprite for ' + _name + ' doesn\'t exist')
		return
	
	var button = inv_button.instance()
	button.get_child(0).set_texture(texture)
	button.set_name(_name)
	button.connect('examine_item', self, 'examine_item')
	$inv_container.add_child(button)

func remove_from_inv(_name):
	for item in $inv_container.get_children():
		if item.name == _name:
			item.queue_free()

func examine_item(_name):
	emit_signal('examine_item', _name)

func get_inv_list():
	var list = []
	for item in $inv_container.get_children():
		list.append(item.name)
	return list

# called when loading a save file
func load_inv(list):
	for item in $inv_container.get_children():
		item.queue_free()
	
	for _name in list:
		add_to_inv(_name)	