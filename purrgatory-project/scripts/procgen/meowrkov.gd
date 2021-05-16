extends Node

const seeds = ["Me", "me"]

func _ready():
	return
	var f = File.new()
	f.open("res://scripts/procgen/meowutkov_edited.json", File.READ)
	var json = JSON.parse(f.get_as_text())
	print(generate_text(json.result, 100))

func generate_text(jdic, threshold_length):
	var output = seeds[randi() % seeds.size()]
	
	while output.length() < threshold_length:
		var key = output.substr(output.length() - 2, 2)
		var sum = 0
		if not key in jdic:
			break
			
		for item in jdic[key]: # for every pair of letters
			sum += int(jdic[key][item]) # sum its count

		var roll = randi() % sum # roll where the sum is the limit
		var rolling_counter = 0
		for item in jdic[key]:
			rolling_counter += jdic[key][item]
			if roll < rolling_counter: # we're in the roll area
				output += item
				break

	return output
	
