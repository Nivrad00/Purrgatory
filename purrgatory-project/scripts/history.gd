extends Control

onready var grid = get_node('container/grid')

var max_history = 50
var history = []

# since the history needs to be rendered for the text formatting to work,
#   it's actually never hidden, just off-screen
func _ready():
	show()
	hide_custom()

func show_custom():
	set_position(Vector2(0, 0))

func hide_custom():
	set_position(Vector2(0, 1600))
	
# stuff is added to history when
# a) the text is updated (in the update_ui function of the ui node), or 
# b) dialog ends (in the end_dialog function of the game node)

func add_space():
	add_to_history(' ', ' ')
	yield(get_tree(), 'idle_frame')
	$container.set_v_scroll($container.get_v_scrollbar().get_max())
	
func add_to_history(s, t):
	# add to log. if history is full, pop some
	history.append([s, t])
	while history.size() > max_history:
		grid.get_child(0).queue_free()
		grid.get_child(1).queue_free()
		history.pop_front()
		
	# this is necessary for reasons unknown
	var a = null
	var b = null
	if history.size() == 1:
		a = Control.new()
		b = Control.new()
		a.set_custom_minimum_size(Vector2(200, 1))
		b.set_custom_minimum_size(Vector2(650, 1))
		grid.add_child(a)
		grid.add_child(b)
	
	# make labels
	var speaker = RichTextLabel.new()
	speaker.set_bbcode('[right]' + s + '[/right]')
	speaker.set_use_bbcode(true)
	speaker.set_mouse_filter(MOUSE_FILTER_IGNORE)
	grid.add_child(speaker)
	
	var text = RichTextLabel.new()
	text.set_bbcode(t)
	text.set_use_bbcode(true)
	text.set_mouse_filter(MOUSE_FILTER_IGNORE)
	grid.add_child(text)
	
	# wait until the text is drawn
	yield(get_tree(), 'idle_frame')
	
	# set heights
	var height = speaker.get_content_height()
	speaker.set_custom_minimum_size(Vector2(200, height))
	
	height = text.get_content_height()
	text.set_custom_minimum_size(Vector2(650, height))
	
	# getting rid of those extra controls 
	if a != null and b != null:
		grid.remove_child(a)
		grid.remove_child(b)
	
	yield(get_tree(), 'idle_frame')
	$container.set_v_scroll($container.get_v_scrollbar().get_max())

# this is called when the font size changes
func format_history():
	var widths = [200, 650]
	var i = 0
	
	for label in grid.get_children():
		var height = label.get_content_height()
		label.set_custom_minimum_size(Vector2(widths[i], height))
		i += 1
		i %= 2

# and THIS is called when a file is loaded
func load_history(_history):
	for label in grid.get_children():
		label.queue_free()
	history = []
	
	# if loading from the main menu, it has to wait for the game to become visible
	#   for the text formatting to work correctly
	if not get_tree().get_root().get_node('main/game').visible:
		yield(get_tree().get_root().get_node('main/game'), 'visibility_changed')
	
	for quote in _history:
		add_to_history(quote[0], quote[1])