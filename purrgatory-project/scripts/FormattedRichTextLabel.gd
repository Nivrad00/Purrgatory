extends RichTextLabel

var copy = null

func _ready():
	call("set_scroll_active", false) # formatting fucks up when there's a scroll bar

func set_bbcode(bbcode):
	# change the text
	set("bbcode_text", bbcode)
	
	# wait to be visible, then wait a frame so the text is drawn
	var really_visible = true
	var node = self
	while node:
		if node is CanvasItem and not node.visible:
			really_visible = false
		node = node.get_parent()
		
	if !really_visible:
		# print('waiting...')
		yield(self, 'visibility_changed')
	yield(get_tree(), 'idle_frame')
	
	# now you can change the height
	var height = call("get_content_height")
	# print(height)
	set_custom_minimum_size(Vector2(get_size().x, height))
	set_size(Vector2(get_size().x, height))

func update_formatting():
	var really_visible = true
	var node = self
	while node:
		if node is CanvasItem and not node.visible:
			really_visible = false
		node = node.get_parent()
			
	if !really_visible:
		# print('waiting...')
		yield(self, 'visibility_changed')
	yield(get_tree(), 'idle_frame')
	
	# now you can change the height
	var height = call("get_content_height")
	set_custom_minimum_size(Vector2(get_size().x, height))
	set_size(Vector2(get_size().x, height))
