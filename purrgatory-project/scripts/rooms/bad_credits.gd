extends 'state_handler_template.gd'

func _on_back_pressed():
	get_node('../../../../..').return_to_main()
