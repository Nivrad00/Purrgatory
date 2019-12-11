extends Node2D

func _ready():
	print($text.get_content_height())
	
func _on_Button_pressed():
	print($text.get_content_height())
