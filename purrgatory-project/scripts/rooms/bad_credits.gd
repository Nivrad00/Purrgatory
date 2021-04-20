extends 'state_handler_template.gd'

func disable_ui():
	# in case it wasn't handled by the previous room
	get_node('../../../../..').disable_ui()
	
func _on_back_pressed():
	get_node('../../../../..').return_to_main()

func skip_credits():
	$AnimationPlayer.stop()
	get_node('1').hide()
	get_node('2').hide()
	get_node('3').hide()
	get_node('4').hide()
	get_node('5').hide()
	get_node('6').hide()
	get_node('7').hide()
	$TextureRect.hide()
	$bg.hide()
	$skip.hide()
	
	$last.show()
	$last/back.show()
	$last/Label2.show()
