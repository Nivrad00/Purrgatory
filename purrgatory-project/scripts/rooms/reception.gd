extends Control

signal start_dialog(label)
signal change_room(label)

# each room should have a separate state-handling script
# (unless that room has no state, in which case you can use state_handler_template.gd)
# it updates the room state based on the game state (for example, making doors accessible once they've been unlocked)

var fade_out_delay = false
var fade_out_trigger = false

func get_value(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false

# modify these functions
func init_state(state):
	pass
	
func update_state(state):
	if fade_out_delay == true:
		fade_out_trigger = true
	if get_value('recep_entered_portal', state):
		fade_out_delay = true

func _process(delta):
	if fade_out_trigger:
		var a = $fadeout.get_modulate().a
		if a == 1:
			fade_out_trigger = false
			$white_timer.start()
			yield($white_timer, 'timeout')
			emit_signal('change_room', 'antechamber1')
		else:
			a = min(a + 0.5 * delta, 1)
			$fadeout.set_modulate(Color(1, 1, 1, a))