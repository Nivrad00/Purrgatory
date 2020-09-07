extends 'state_handler_template.gd'

func _ready():
	$meowseum_door_locked.set_highlight_on_hover(false)
	
func update_state(state):
	.update_state(state)
	
	$bg.hide()
	$bg_unlocked.hide()
	$meowseum_door_exit.hide()
	$meowseum_door_locked.hide()
	$padlock.hide()
	
	if state.get('opened_meowseum_door'):
		$bg_unlocked.show()
		$meowseum_door_exit.show()
		$padlock.show()
	else:
		$bg.show()
		$meowseum_door_locked.show()