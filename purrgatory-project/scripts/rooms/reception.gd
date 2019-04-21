extends Control

signal start_dialog(label, sprite)
signal change_room(label)

# each room should have a separate state-handling script
# (unless that room has no state, in which case you can use state_handler_template.gd)
# it updates the room state based on the game state (for example, making doors accessible once they've been unlocked)

var fade_out_delay = false
var fade_out_trigger = false
var charon_moving = false
	
func get_value(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false

# modify these functions
func init_state(state):
	pass
	
func update_state(state):
	if get_value('enable_name_input', state):
		state['enable_name_input'] = false
		get_node('/root/game/ui/name_input').show()
		get_node('/root/game/ui/name_input/text').grab_focus()
		
	if get_value('enable_name_input_flag', state):
		state['enable_name_input'] = true
		state['enable_name_input_flag'] = false
		
	if get_value('met_receptionist', state):
		charon_moving = true
		$receptionist_idle.hide()
		$receptionist_idle2.show()		
	if fade_out_delay == true:
		fade_out_trigger = true
		$portal_audio.play()
		$portal.hide()
	if get_value('recep_entered_portal', state):
		fade_out_delay = true

func _process(delta):
	if charon_moving:
		var pos = $receptionist_idle2.get_position()
		$receptionist_idle2.set_position(Vector2(pos.x - 5 * delta, pos.y))
	if fade_out_trigger:
		var a = $fadeout.get_modulate().a
		if a == 1:
			fade_out_trigger = false
			$white_timer.start()
			yield($white_timer, 'timeout')
			emit_signal('change_room', 'antechamber1')
		else:
			a = min(a + 0.2 * delta, 1)
			$fadeout.set_modulate(Color(1, 1, 1, a))