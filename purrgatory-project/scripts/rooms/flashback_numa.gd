extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 3: 2 }
	ending_label = null

func wake_up():
	.wake_up()
	
	var replacements = [
		'see the mountains',
		'hear the streets',
		'smell the ocean',
		'see the dusty roads',
		'feel the muggy air', 
		'see the perfect lawns',
		'see the leaky roof'
	]
	set_format_dict('hometown', replacements[choice_log[1]])
	
	var replacements2 = [
		'the corner store',
		'the creek',
		'the bookstore',
		'my great-aunt\'s house',
		'the arcade', 
		'the back of my family\'s store',
		'the soccer field'
	]
	set_format_dict('favorite_place', replacements2[choice_log[2]])
	
	emit_signal('change_room', 'flashback_kyungsoon')