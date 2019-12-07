extends Control

func _on_Button_pressed():
	
	var img2 = $Viewport.get_texture().get_data()
	img2.flip_y()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	img2.save_png("user://test2.png")
	
	var img1 = get_viewport().get_texture().get_data()
	img1.flip_y()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	img1.save_png("user://test1.png")
