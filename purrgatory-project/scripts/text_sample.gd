extends RichTextLabel

func _on_text_size_value_changed(value):
	get_font('normal_font').set_size(value)
	get_font('italics_font').set_size(value)
	var bb = get_bbcode()
	clear()
	set_bbcode(bb)