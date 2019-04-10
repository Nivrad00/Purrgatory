extends Node2D

func disable_all():
	for node in get_children():
		if 'disabled' in node:
			node.disabled = true
			
func enable_all():
	for node in get_children():
		if 'disabled' in node:
			node.disabled = false