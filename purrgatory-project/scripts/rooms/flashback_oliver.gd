extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 4: 3 }
	ending_label = 'oliver_end_pride_flashback'
	
func update_state(state):
	.update_state(state)
	if state.get('flashback_goto_commons'):
		emit_signal('change_room', 'commons1')
