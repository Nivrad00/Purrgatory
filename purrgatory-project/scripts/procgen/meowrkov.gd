extends Node


const seeds = ["Me", "me"]

func _ready():
	var f = File.new()
	f.open("res://scripts/procgen/meowkov.json", File.READ)
	var json = JSON.parse(f.get_as_text())
	print(generate_text(json.result, 100))

func generate_text(jdic, threshold_length):
	var output = seeds[randi() % seeds.size()]
	
	var count = 0
	var last_out = ""
	while count <= threshold_length or \
		  (count > threshold_length and \
			(not (last_out in [",", "."]))):
			var key = output.substr(output.length() - 2, 2)
			var list = jdic[key]
			last_out = list[randi() % list.size()]
			output += last_out
			count += 1
	
	return output
	
