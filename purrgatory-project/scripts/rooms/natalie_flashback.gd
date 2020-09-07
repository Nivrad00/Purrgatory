extends "flashback_template.gd"

func _ready():
	._ready()

func init_state(state):
	.init_state(state)
	state['natalie_quest_complete'] = true
	
func wake_up():
	.wake_up()
	emit_signal('start_dialog', 'natalie_post2', [])