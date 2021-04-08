extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 2: 1 }
	ending_label = "end_flashback"

func init_state(state):
	.init_state(state)
	state['tori_quest_complete'] = true
	state['queue_tori_flashback'] = false
	
func wake_up():
	.wake_up()
	emit_signal('change_room', 'warehouse3')
	
	set_format_dict('setback', choice_text[3])
	set_format_dict('desire', choice_text[1])
