extends Button

onready var dropdown = get_node('../dropdown')
var flashing = false

func flash():
	if flashing:
		return # don't start the flashing animation if it's already going
	
	flashing = true
		
	for x in range(4):
		$flash_timer.start()
		yield($flash_timer, 'timeout')
		set_modulate(Color(0.9, 0.9, 0.9))
		$flash_timer.start()
		yield($flash_timer, 'timeout')
		set_modulate(Color(1, 1, 1, 1))
	
	# set it back to whatever color it should be
	if dropdown.items_shown:
		set_modulate(Color(0.9, 0.9, 0.9))
	else:
		set_modulate(Color(1, 1, 1, 1))
		
	flashing = false