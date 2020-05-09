extends "flashback_template.gd"

func _ready():
	._ready()
	ending_label = null

func wake_up():
	.wake_up()
	emit_signal('change_room', 'flashback_sean')