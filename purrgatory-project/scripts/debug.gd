extends Control

onready var game = get_node('../..')

func _on_Button_pressed():
	game.state[get_node('LineEdit').text] = true

func _on_Button2_pressed():
	game.state[get_node('LineEdit').text] = false

func _on_Button3_pressed():
	game.change_room(get_node('LineEdit2').text)
