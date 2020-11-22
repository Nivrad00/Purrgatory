extends "flashback_template.gd"

func _ready():
	._ready()
	ending_label = "ks_post_flashback"
	
func wake_up():
	.wake_up()
	
	set_format_dict('food', choice_text[1])