extends Control

onready var grid = get_node('container/grid')

func show_history(history):
	for child in grid.get_children():
		child.queue_free()
		
	var font = grid.get_font('normal_font')
	var text_height = font.get_height() * 1.15
	
	for pair in history:
		if pair == null:
			continue # placeholder
		
		# make new labels
		var speaker = RichTextLabel.new()
		speaker.set_bbcode('[right]' + pair[0] + '[/right]')
		speaker.set_use_bbcode(true)
		speaker.set_custom_minimum_size(Vector2(200, text_height))
		grid.add_child(speaker)
		
		var text = RichTextLabel.new()
		text.set_bbcode(pair[1])
		text.set_use_bbcode(true)
		text.set_custom_minimum_size(Vector2(650, text_height))
		grid.add_child(text)
		
		# set the sizes
		# var height = speaker.get_content_height()
		# speaker.set_custom_minimum_size(Vector2(200, height))
		
		# height = text.get_content_height()
		# text.set_custom_minimum_size(Vector2(650, height))
	
	show()