extends Control

signal start_dialog(label, sprite)
signal change_room(label)
signal set_hidden_sprite(sprite)

# each room should have a separate state-handling script
# (unless that room has no state, in which case you can use state_handler_template.gd)
# it updates the room state based on the game state (for example, making doors accessible once they've been unlocked)

func get_value(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false

# modify these functions
func init_state(state):
	pass
	
func update_state(state):
	if get_value('elijah_goto_garden', state):
		emit_signal('change_room', 'garden6')
		state['elijah_goto_garden'] = false
		
	if get_value('display_elijah_and_sean', state):
		emit_signal('set_hidden_sprite', [$elijah_idle, $sean_idle])
		state['display_elijah_and_sean'] = false
		
	if get_value('display_sean', state):
		emit_signal('set_hidden_sprite', [$sean_idle])
		state['display_sean'] = false
		
	for child in get_children():
		var key = '_inv_' + child.name
		if get_value(key, state):
			child.hide()