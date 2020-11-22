extends "flashback_template.gd"

func _ready():
	._ready()
	ending_label = null

func wake_up():
	.wake_up()
	
	set_format_dict('role_model', choice_text[1])
	set_format_dict('envy', choice_text[2])
	
	emit_signal('change_room', 'flashback_sean')