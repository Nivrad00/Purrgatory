extends Control

signal start_dialog(label, sprite)
signal change_room(label)
signal set_hidden_sprite(sprite)
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
	# if you just went from flowerbed to garden6
	if get_value('flowers_goto_garden', state):
		emit_signal('set_hidden_sprite', [$numa])
		state['flowers_goto_garden'] = false
	
func update_state(state):
	for child in get_children():
		var key = '_inv_' + child.name
		if get_value(key, state):
			child.hide()
	
	$numa.show()
	
	# numa's intro
	
	if get_value('trample_flag', state):
		$numa2.show()
	else:
		$numa2.hide()
		
	if get_value('trample_flag', state) and not get_value('nearly_trampled_flower', state):
		$exit_dialog.show()
	else:
		$exit_dialog.hide()
		
	# numa's quest
	
	if get_value('numa_goto_flowerbed', state):
		emit_signal('change_room', 'flowerbed')
		state['numa_goto_flowerbed'] = false
		
	if get_value('elijah_show_numa', state):
		emit_signal('set_hidden_sprite', [$numa])
		state['elijah_show_numa'] = false
	
	if get_value('poetry_session', state):
		$numa.hide()
		$numa_with_elijah.show()
		$elijah_with_numa.show()
	else:
		$numa_with_elijah.hide()
		$elijah_with_numa.hide()
	
	if get_value('elijah_working_with_numa_timer', state):
		state['elijah_working_with_numa_timer'] = false
		state['poetry_session'] = true
		emit_signal('start_action_timer', 20, ['poetry_session', false])
		
	if get_value('numa_goto_commons', state):
		emit_signal('change_room', 'hallway1')
		state['numa_goto_commons'] = false
		
	if get_value('numa_crying', state) or get_value('numa_quest_complete', state):
		$numa.hide()
	
func end_poetry_session(state):
	state['poetry_session'] = false
	