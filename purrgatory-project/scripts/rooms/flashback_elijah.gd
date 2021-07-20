extends "flashback_template.gd"

func _ready():
	._ready()
	ending_label = null

func wake_up():
	.wake_up()
	
	var replacements = [
		'an estranged family member',
		'a childhood friend',
		'an artist',
		'a high school teacher',
		'a bassist in this band i liked',
		'a character from this tv show i liked',
		'my closest friend'
	]
	set_format_dict('role_model', replacements[choice_log[1]])
	set_format_dict('envy', choice_text[2])
	
	emit_signal('change_room', 'flashback_sean')