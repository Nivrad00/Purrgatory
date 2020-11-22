extends 'state_handler_template.gd'

var anim_playing = false
onready var state_copy = get_node('../../../../..').state

func init_state(state):
	.init_state(state)
	if state.get('house_cat_pushed_glass'):
		$house_glass.hide()

func update_state(state):
	.update_state(state)
	if state.get('house_cat_pushing_glass'):
		$house_glass.hide()
		$glass_timer.start()
		$glass_cover.show()
		anim_playing = true

func _on_glass_timer_timeout():
	$shatter.play()
	anim_playing = false
	
func _on_glass_cover_pressed():
	print('boooop')
	if not anim_playing:
		state_copy['house_cat_pushing_glass'] = false
		$glass_cover.hide()
		emit_signal('start_dialog', 'house_glass_next', [])
