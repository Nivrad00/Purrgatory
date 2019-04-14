extends Node2D

func _ready():
	var json = get_tree().get_root().get_node('game').meowkov_json
	$text.text = $meowkov.generate_text(json.result, 1000)
	$text2.text = $meowkov.generate_text(json.result, 1000)
