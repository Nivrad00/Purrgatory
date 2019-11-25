extends Label

func _on_text_size_value_changed(value):
	get("custom_fonts/font").set_size(value)