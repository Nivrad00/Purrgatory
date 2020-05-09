extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 2: 1 }
	ending_label = "end_flashback"
	
func wake_up():
	.wake_up()
	emit_signal('change_room', 'garden4')