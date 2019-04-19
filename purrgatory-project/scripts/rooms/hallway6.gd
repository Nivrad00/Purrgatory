extends Control

signal start_dialog(label, sprite)
signal change_room(label)
signal start_action_timer(actions, callback)

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
	for child in get_children():
		var key = '_inv_' + child.name
		if get_value(key, state):
			child.hide()
			
	if get_value('opened_vent', state) and !get_value('numa_snooped', state):
		$vent_open.show()
		$vent_closed.hide()
	else:
		$vent_open.hide()
		$vent_closed.show()
		
	if get_value('ks_at_vent', state):
		$kyungsoon_at_vent.show()
	else:
		$kyungsoon_at_vent.hide()
		
	if get_value('ks_at_vent_timer', state):
		state['ks_at_vent_timer'] = false
		state['ks_at_vent'] = true
		emit_signal('start_action_timer', 10, ['ks_at_vent', false])
		emit_signal('start_action_timer', 10, ['numa_at_commons', true])