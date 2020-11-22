extends "flashback_template.gd"

func _ready():
	._ready()

func init_state(state):
	.init_state(state)
	state['natalie_quest_complete'] = true
	
func wake_up():
	.wake_up()
		
	set_format_dict('dream', choice_text[1])
	set_format_dict('regret', choice_text[3])
	
	emit_signal('start_dialog', 'natalie_post2', [])