extends Button

signal examine_item(_name)

func _on_inv_button_pressed():
	emit_signal('examine_item', name)
	
