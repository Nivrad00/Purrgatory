extends Node

var blocks = {}

func get_state(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false
		
func get_block(label, state):
	return blocks[label]