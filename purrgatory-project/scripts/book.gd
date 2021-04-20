extends Node2D

func _ready():
	load_meows() 
	
func load_meows():
	var json = get_node('/root/main/game').meowkov_json
	if json != null:
		$Viewport/text.text = $meowkov.generate_text(json.result, 1000).replacen('\n', '\n\n')
		$Viewport/text2.text = $meowkov.generate_text(json.result, 1000).replacen('\n', '\n\n')
