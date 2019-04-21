extends Node

var loader

func _on_start_pressed():
	$main_menu.hide()
	$game.show()

func _on_credits_pressed():
	$main_menu.hide()
	$credits.show()
	
func _on_exit_pressed():
	get_tree().quit()

func _on_back_pressed():
	$credits.hide()
	$main_menu.show()
