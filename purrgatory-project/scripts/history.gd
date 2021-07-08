extends Control

onready var grid = get_node('container/grid')

var max_history = 50
var history = []
var widths = [150, 700]

# since the history needs to be rendered for the text formatting to work,
#   it's actually never hidden, just off-screen
func _ready():
	show()
	hide_custom()

func show_custom():
	set_position(Vector2(0, 0))
	$'../../content/ui/choices'.hide()
	$'../../content/ui/text_box'.hide()
	$'../../content/ui/skip_button'.hide()
	$'../menu_button'.hide()
	$'../notes_button'.hide()
	$'../items_button'.hide()

func hide_custom():
	set_position(Vector2(0, 1600))
	$'../../content/ui/choices'.show()
	$'../../content/ui/text_box'.show()
	$'../../content/ui/skip_button'.show()
	$'../menu_button'.show()
	$'../notes_button'.show()
	$'../items_button'.show()
		

func toggle():
	if rect_position.y > 0:
		show_custom()
	else:
		hide_custom()
	
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
		a.set_custom_minimum_size(Vector2(widths[0], 1))
		b.set_custom_minimum_size(Vector2(widths[1], 1))
		grid.add_child(a)
		grid.add_child(b)
	
	# make labels, including the width
	var speaker = RichTextLabel.new()
	speaker.set_bbcode('[right]' + s + '[/right]')
	speaker.set_use_bbcode(true)
	speaker.set_mouse_filter(MOUSE_FILTER_IGNORE)
	speaker.set_custom_minimum_size(Vector2(widths[0], 500))
	speaker.scroll_active = false
	grid.add_child(speaker)
	
	var text = RichTextLabel.new()
	text.set_bbcode(t)
	text.set_use_bbcode(true)
	text.set_mouse_filter(MOUSE_FILTER_IGNORE)
	text.set_custom_minimum_size(Vector2(widths[1], 500))
	speaker.scroll_active = false
	grid.add_child(text)
	
	# wait until the text is drawn
	yield(get_tree(), 'idle_frame')
	
	# do a second pass to set heights
	var height = speaker.get_content_height()
	speaker.set_custom_minimum_size(Vector2(widths[0], height))
	
	height = text.get_content_height()
	text.set_custom_minimum_size(Vector2(widths[1], height))
	
	# getting rid of those extra controls 
	if a != null and b != null:
		grid.remove_child(a)
		grid.remove_child(b)
	
	yield(get_tree(), 'idle_frame')
	$container.set_v_scroll($container.get_v_scrollbar().get_max())

# this is called when the font size changes
func format_history():
	widths = [150, 700]
	var i = 0
	
	# the first column should be wide enough to print "kyungsoon", at least
	# sike, the longest name is actually "receptionist"
	#... double sike, apparently kyungsoon is what we need??
	var kyungsoon_width = $container.get_font('normal_font').get_string_size('kyungsoon').x
	
	if widths[0] < kyungsoon_width + 60:
		widths[0] = kyungsoon_width + 60
		widths[1] = 850 - widths[0]
	
	# first pass: set widths
	for label in grid.get_children():
		if label is RichTextLabel:
			# var height = label.rect_min_size.y
			label.set_custom_minimum_size(Vector2(widths[i], 500))
			
			i += 1
			i %= 2
				
	# let that change be drawn
	yield(get_tree(), "idle_frame")
	
	# second pass: set heights
	for label in grid.get_children():
		if label is RichTextLabel:
			var width = label.rect_min_size.x
			var height = label.get_content_height()
			label.set_custom_minimum_size(Vector2(width, height))

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
	
	yield(get_tree(), 'idle_frame')
	format_history()

