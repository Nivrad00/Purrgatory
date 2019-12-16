extends Control

signal examine_item(_name)

# max height of the box image itself is around 280 or so
onready var default_height = get_position().y
onready var notes_max_height = default_height + 250
onready var items_height = default_height + 125

var speed = 20
var move = false
var items_shown = false
var notes_shown = false
var target_height = -1

onready var notes_button = get_node('../notes_button')
onready var items_button = get_node('../items_button')

var inv_sprite_path = 'res://assets/sprites/inv/'
var inv_button = preload('res://scenes/inv_button.tscn')

onready var quests = load('res://scripts/quests.gd').new().quests

var FormattedRichTextLabel = preload('res://scenes/FormattedRichTextLabel.tscn')

var notes_enabled = false

func _ready():
	set_process(true) 
	add_quest('nothing')
	
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
	
		$inv_container.hide()
		$quest_container.show()
		
		notes_shown = true
		notes_button.set_modulate(Color(0.9, 0.9, 0.9))
		
		format_quests()
	
func toggle_items():
	if items_shown:
		items_shown = false
		hide_all()
	else:
		if notes_shown:
			notes_shown = false
			notes_button.set_modulate(Color(1, 1, 1))
			
		$inv_container.show()
		$quest_container.hide()
		
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
		else:
			var target = Vector2(pos.x, target_height)
			set_position(pos + (target - pos)/2 * delta * speed)

func add_to_inv(_name):
	for item in $inv_container.get_children():
		if item.name == _name:
			print(_name + ' is already in the inventory')
			return
			
	var texture = load(inv_sprite_path + _name + '.png')
	if texture == null:
		print('uh boss the inventory sprite for ' + _name + ' doesn\'t exist')
		return
	
	var button = inv_button.instance()
	button.get_child(0).set_texture(texture)
	button.set_name(_name)
	button.connect('examine_item', self, 'examine_item')
	$inv_container.add_child(button)
	
	if not items_shown:
		toggle_items()
		# items_button.flash()

func remove_from_inv(_name):
	for item in $inv_container.get_children():
		if item.name == _name:
			item.queue_free()
			
	if not items_shown:
		items_button.flash()

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
	
	yield(get_tree(), 'idle_frame')
	
	for _name in list:
		add_to_inv(_name)

func add_quest(quest):
	for item in $quest_container/vbox.get_children():
		if item.name == quest:
			print(quest + ' is already on the quest log, can\'t add it')
			return
	
	if not quests.has(quest):
		print('no text found for quest ' + quest + ', can\'t add it')
		return
		
	var label = FormattedRichTextLabel.instance()
	label.set_name(quest)
	$quest_container/vbox.add_child(label)
	
	label.set_size(Vector2($quest_container.get_size().x, 0))
	label.set_custom_minimum_size(Vector2($quest_container.get_size().x, 0))
	label.set_bbcode(quests[quest])
	
	# if there's a placeholder, remove it
	# also remember not to do this if the thing you just added was the placeholder
	if quest != 'nothing':
		for item in $quest_container/vbox.get_children():
			if item.name == 'nothing':
				item.queue_free()
		
	if notes_shown:
		format_quests()

func remove_quest(quest):
	for item in $quest_container/vbox.get_children():
		if item.name == quest:
			item.queue_free()
			
			# if there are no quests left, add a placeholder
			# no need to format in this case, bc the add_quest method will do it 
			yield(get_tree(), 'idle_frame')
			if $quest_container/vbox.get_children().size() == 0:
				add_quest('nothing')
			elif notes_shown:
				format_quests()
				
			return
	
	print('can\'t find quest ' + quest + ' on the quest log to remove it')

func format_quests():
	yield(get_tree(), 'idle_frame')
		
	for item in $quest_container/vbox.get_children():
		item.update_formatting()
		
	yield(get_tree(), 'idle_frame')
	
	if notes_shown:
		target_height = min(default_height + get_quest_log_size() + 30, notes_max_height)
		move = true

func get_quest_log_size():
	# this shouldn't ever happen
	if $quest_container/vbox.get_children().size() == 0:
		return 90
		
	var sum = 0
	for item in $quest_container/vbox.get_children():
		if item is RichTextLabel:
			sum += item.get_size().y
			sum += $quest_container.get_theme().get_constant('separation', 'VBoxContainer')
	return sum

func get_quest_log():
	var list = []
	for item in $quest_container/vbox.get_children():
		list.append(item.name)
	return list
	
# called when loading a save file
func load_quest_log(list):
	for item in $quest_container/vbox.get_children():
		item.queue_free()
	
	# wait for the items to go away so there's no name clash
	yield(get_tree(), 'idle_frame') 
	
	for _name in list:
		add_quest(_name)

func toggle_quest_log(on):
	notes_enabled = on
	if on:
		notes_button.show()
	else:
		if notes_shown:
	 		toggle_notes()
		notes_button.hide()