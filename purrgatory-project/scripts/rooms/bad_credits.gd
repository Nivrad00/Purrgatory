extends 'state_handler_template.gd'

func show_rotating_cat():
	get_node('../../../rotating_cat_container').rect_position = Vector2(289, 180)
	get_node('../../../rotating_cat_container').rect_scale = Vector2(0.6, 0.6)
	get_node('../../../rotating_cat_container').modulate.a = 1
	
func hide_rotating_cat():
	get_node('../../../rotating_cat_container').rect_position = Vector2(0, 0)
	get_node('../../../rotating_cat_container').rect_scale = Vector2(0.001, 0.001)
	get_node('../../../rotating_cat_container').modulate.a = 0.01
		
func disable_ui():
	# in case it wasn't handled by the previous room
	get_node('../../../../..').disable_ui()
	
func _on_back_pressed():
	get_node('../../../../..').return_to_main()

func skip_bad_credits():
	$AnimationPlayer.stop()
	get_node('1').hide()
	get_node('2').hide()
	get_node('3').hide()
	get_node('4').hide()
	get_node('5').hide()
	get_node('6').hide()
	get_node('7').hide()
	$TextureRect.hide()
	$skip.hide()
	
	$last.show()
	$last/back.show()
	$last/Label2.show()

func skip_good_credits():
	$AnimationPlayer.stop()
	get_node('1').hide()
	get_node('2').hide()
	get_node('3').hide()
	get_node('4').hide()
	get_node('5').hide()
	get_node('6').hide()
	get_node('7').hide()
	get_node('8').hide()
	$skip.hide()
	
	$last.show()
	
	hide_rotating_cat()
