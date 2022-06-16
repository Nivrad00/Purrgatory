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

var snowglobes = []

# when the inventory bar is being "flashed," this is true
var pending_change = false

func _ready():
	set_process(true) 
	add_quest('nothing')
	
func hide_all():
	notes_button.set_modulate(Color(1, 1, 1))
	items_button.set_modulate(Color(1, 1, 1))
	target_height = default_height
	move = true
	
func toggle_notes():	
	pending_change = false
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
		notes_button.set_modulate(Color(0.85, 0.85, 0.85))
		
		format_quests()
	
func toggle_items(temporary=false):
	pending_change = false
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
		items_button.set_modulate(Color(0.85, 0.85, 0.85))
		target_height = items_height
		move = true
		
		if temporary:
			pending_change = true
			
			yield(get_tree().create_timer(1.3), 'timeout')
			
			if pending_change:
				items_shown = false
				pending_change = false
				hide_all()
		

func _process(delta):
	if move:
		var pos = get_position()
		if target_height == -1 or target_height == pos.y:
			target_height == -1
			move = false
		else:
			var target = Vector2(pos.x, target_height)
			set_position(pos + (target - pos)/2 * delta * speed)

func add_to_inv(_name, loading = false):
	for item in $inv_container.get_children():
		if item.name == _name:
			return
	
	for snowglobe_name in snowglobes:
		if snowglobe_name == _name:
			return
			
	print("added to inventory: " + _name)
	
	var texture = null
	
	# snowglobes are an exception
	if _name.substr(0, 9) == 'snowglobe':
		snowglobes.append(_name)
		
		# if there's already snowglobes in the inv, just update the button then return
		for item in $inv_container.get_children():
			if item.name.substr(0, 9) == 'snowglobe':
				var count = int(item.name.substr(9, 10))
				texture = load(inv_sprite_path + 'snowglobe' + str(count + 1) + '.png')
				item.get_child(0).set_texture(texture)
				item.set_name('snowglobe' + str(count + 1))
				
				# this shouldn't happen when loading a save file
				if not items_shown and not loading:
					toggle_items(true)
		
				return
		
		# else, load snowglobe1	
		_name = 'snowglobe1'
			
	texture = load(inv_sprite_path + _name + '.png')
	if texture == null:
		print('uh boss the inventory sprite for ' + _name + ' doesn\'t exist')
		return
	
	var button = inv_button.instance()
	button.get_child(0).set_texture(texture)
	button.set_name(_name)
	button.connect('examine_item', self, 'examine_item')
	$inv_container.add_child(button)
	
	# this shouldn't happen when loading a save file
	if not items_shown and not loading:
		toggle_items(true)
		# items_button.flash()

func remove_from_inv(_name, flash = true):
	# exception for snowglobes
	if _name == 'snowglobes':
		# remove from inventory box
		for item in $inv_container.get_children():
			if item.name.substr(0, 9) == 'snowglobe':
				item.queue_free()
		# remove from internal list
		snowglobes = []
		# remove from state
		var state = get_tree().get_root().get_node('main/game').state
		for key in state:
			if key.substr(0, 14) == '_inv_snowglobe' and state[key]:
				state[key] = false
		return
		
	# everything else
	var found = false
	for item in $inv_container.get_children():
		if item.name == _name:
			item.queue_free()
			found = true
			
	if flash and found and not items_shown:
		items_button.flash()

func examine_item(_name):
	emit_signal('examine_item', _name)

func get_inv_list():
	var list = []
	
	for snowglobe in snowglobes:
		list.append(snowglobe)
		
	for item in $inv_container.get_children():
		if not item.name.substr(0, 9) == 'snowglobe':
			list.append(item.name)
			
	return list

# called when loading a save file
func load_inv(list):
	pending_change = false
	for item in $inv_container.get_children():
		item.queue_free()
	snowglobes = []
	
	yield(get_tree(), 'idle_frame')
	
	for _name in list:
		add_to_inv(_name, true) # tell it that you're loading a new file

func add_quest(quest):
	for item in $quest_container/vbox.get_children():
		if item.name == quest:
			return
	
	if not quests.has(quest):
		print('no text found for quest ' + quest + ', can\'t add it')
		return
		
	var label = FormattedRichTextLabel.instance()
	label.set_name(quest)
	$quest_container/vbox.add_child(label)
	
	label.set_size(Vector2($quest_container.get_size().x, 0))
	label.set_custom_minimum_size(Vector2($quest_container.get_size().x, 0))
	label.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	
	label.set_bbcode(quests[quest][Language.language])
	label.translations = []
	for lang in quests[quest]:
		label.translations.append(lang)
	
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
	pending_change = false
	for item in $quest_container/vbox.get_children():
		item.queue_free()
	
	# wait for the items to go away so there's no name clash
	yield(get_tree(), 'idle_frame') 
	
	for _name in list:
		add_quest(_name)
		
	yield(get_tree(), 'idle_frame') 
	
	# if there are no quests, add a placeholder
	if $quest_container/vbox.get_children().size() == 0:
		add_quest('nothing')

func toggle_quest_log(on):
	# we removed this functionality, so
	on = true
	
	notes_enabled = on
	if on:
		notes_button.show()
	else:
		if notes_shown:
			toggle_notes()
		notes_button.hide()
