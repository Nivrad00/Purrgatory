extends 'state_handler_template.gd'

var anim_playing = false
onready var state_copy = get_node('../../../../..').state

func update_state(state):
	.update_state(state)
	
	if state.get('cat_in_house'):
		$house_cat.show()
	else:
		$house_cat.hide()
		
	if state.get('house_cat_pushed_glass') and not state.get('house_cat_pushing_glass'):
		$house_glass.hide()
		
	if state.get('house_cat_pushing_glass'):
		$glass_animation.play('glass_push')
		$glass_cover.show()
		anim_playing = true

func _on_glass_cover_pressed():
	if not anim_playing:
		state_copy['house_cat_pushing_glass'] = false
		$glass_cover.hide()
		emit_signal('start_dialog', 'house_glass_next', [])

func _on_glass_animation_animation_finished(_anim_name):
	anim_playing = false
