extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 3: 2 }
	ending_label = 'oliver_end_pride_flashback'
		
func wake_up():
	.wake_up()
	
	var replacements = [ 
		'always nice to strangers',
		'always honest',
		'pretty smart and well-spoken',
		'good-looking',
		'always there for my friends',
		'a decent musician',
		'always optimistic'
	]
	
	set_format_dict('pride', replacements[choice_log[1]])
	set_format_dict('proudest_moment', choice_text[2])
	
func update_state(state):
	.update_state(state)
	if state.get('flashback_goto_commons'):
		emit_signal('change_room', 'commons1')
