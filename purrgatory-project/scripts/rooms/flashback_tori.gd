extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 2: 1, 3: 1 }
	ending_label = "end_flashback"

func init_state(state):
	.init_state(state)
	state['tori_quest_complete'] = true
	state['queue_tori_flashback'] = false
	
func wake_up():
	.wake_up()
	emit_signal('change_room', 'warehouse3')
	
	set_format_dict('desire', choice_text[1])
	
	var desire_es_replacements = [
		'el conocimiento',
		'la amistad',
		'la aventura',
		'la destreza',
		'la felicidad',
		'la libertad',
		'el amor'
	]
	set_format_dict('desire_es', desire_es_replacements[choice_log[1]])
	
	# chinese (placeholder)
	
	set_format_dict('desire_ch', choice_text[1])
