extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 2: 1 }
	ending_label = "end_flashback"
	
func wake_up():
	.wake_up()
	
	var replacements = [
		'partner',
		'best friend',
		'partner'
	]
	set_format_dict('partner_name', input_text[2])
	set_format_dict('partner', replacements[choice_log[1]])
	set_format_dict('partner_about', choice_text[3])
	
	emit_signal('change_room', 'garden4')