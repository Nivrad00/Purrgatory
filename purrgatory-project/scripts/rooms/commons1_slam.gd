extends 'state_handler_template.gd'

func _ready():
	$slam_exit.set_highlight_on_hover(true)
	$exit.set_highlight_on_hover(true)
	
func init_state(state):
	.init_state(state)
	
func update_state(state):
	.update_state(state)
	
	# the books that oliver gives ks at the end of his quest
	if state.get('gifted_books'):
		$gift_books.show()
	else:
		$gift_books.hide()
	
	# the flowers that numa drops near the end of her quest
	if state.get('commons_flowers'):
		$flowers_etc.show()
	else:
		$flowers_etc.hide()
		
	# cat toy easter egg
	if state.get('gave_cat_toy'):
		$cat1_idle/cat_toy.show()
		$cat_toy_stick.show()
	else:
		$cat1_idle/cat_toy.hide()
		$cat_toy_stick.hide()
	
	# kyungsoon is always there
	$slam_kyungsoon.show()
	
	# slam stuff
	$slam_oliver.hide()
	$slam_numa.hide()
	$exit3.hide()
	$slam_exit.show()
	$slam_elijah_after.hide()
	
	if state.get('post_slam'):
		$slam_elijah_after.show()
	elif state.get('slam_outro'):
		pass
	elif state.get('looking_for_poem'):
		# this is the only state where you can actually leave the commons normally
		$exit3.show()
		$slam_exit.hide()
	elif state.get('slam_intro'):
		pass
	else:
		$slam_oliver.show()
		$slam_numa.show()
