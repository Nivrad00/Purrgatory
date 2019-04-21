extends Control

var game = null

func _ready():
	game = load("res://scenes/game.tscn")

func _on_start_pressed():
	get_tree().change_scene("res://scenes/game.tscn")

func _on_credits_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	pass # Replace with function body.
