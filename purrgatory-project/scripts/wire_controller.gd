extends GridContainer

var hovered_tile = null
var origin = null

var clickable = ['node', 'node_up', 'node_right', 'node_down', 'node_left', 'end_up', 'end_right', 'end_down', 'end_left']

func _ready():
	var buttons = get_children()
	var _max = pow(columns, 2)
	for i in range(_max):
		if i - columns >= 0:
			buttons[i].adjacent['up'] = buttons[i - columns]
		if i + columns < _max:
			buttons[i].adjacent['down'] = buttons[i + columns]
		if i % 8 != 0:
			buttons[i].adjacent['left'] = buttons[i - 1]
		if i % 8 != 7:
			buttons[i].adjacent['right'] = buttons[i + 1]

func reset_button(button):
	button.origin = null
	if button.tile.substr(0, 4) == 'node':
		button.set_tile('node')
		button.path = [button]
	else:
		button.set_tile('blank')
	
func release_wire():
	origin = null
	
	# set the cursor shapes back to what they should be
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	for button in get_children():
		button.mouse_default_cursor_shape = button.cursor_shape
		
func mouse_entered(button):
	hovered_tile = button
		
	# if a wire is being dragged
	if origin:
		var current = origin.path[origin.path.size() - 1]
		var prev = null
		if origin.path.size() >= 2:
			prev = origin.path[origin.path.size() - 2]
		
		# if they dragged the wire forward
		if (hovered_tile.tile == 'blank' or hovered_tile.tile.substr(0, 4) == 'node' or hovered_tile.tile.substr(0, 3) == 'end')\
		and hovered_tile in current.adjacent.values()\
		and (not (current.tile.substr(0, 4) == 'node' and current.origin))\
		and hovered_tile != origin:
			origin.path.append(hovered_tile)
			current = origin.path[origin.path.size() - 1]
			prev = origin.path[origin.path.size() - 2]
			var prev2 = null
			if origin.path.size() >= 3:
				prev2 = origin.path[origin.path.size() - 3]
			
			# first, deal with prev
			# if prev2 exists, fill in prev according to prev2 and current
			if prev2:
				if current == prev.adjacent['up'] and prev == prev2.adjacent['up']\
				or current == prev.adjacent['down'] and prev == prev2.adjacent['down']:
					prev.set_tile('wire_up')
					
				if current == prev.adjacent['left'] and prev == prev2.adjacent['left']\
				or current == prev.adjacent['right'] and prev == prev2.adjacent['right']:
					prev.set_tile('wire_right')
					
				if current == prev.adjacent['up'] and prev == prev2.adjacent['left']\
				or current == prev.adjacent['right'] and prev == prev2.adjacent['down']:
					prev.set_tile('wire_up_right')
					
				if current == prev.adjacent['down'] and prev == prev2.adjacent['left']\
				or current == prev.adjacent['right'] and prev == prev2.adjacent['up']:
					prev.set_tile('wire_down_right')
					
				if current == prev.adjacent['left'] and prev == prev2.adjacent['up']\
				or current == prev.adjacent['down'] and prev == prev2.adjacent['right']:
					prev.set_tile('wire_down_left')
					
				if current == prev.adjacent['up'] and prev == prev2.adjacent['right']\
				or current == prev.adjacent['left'] and prev == prev2.adjacent['down']:
					prev.set_tile('wire_up_left')
			
			# else, you're one tile away from the starting node
			elif prev.tile.substr(0, 4) == 'node':
				if current == prev.adjacent['up']:
					prev.set_tile('node_up')
				elif current == prev.adjacent['right']:
					prev.set_tile('node_right')
				elif current == prev.adjacent['down']:
					prev.set_tile('node_down')
				elif current == prev.adjacent['left']:
					prev.set_tile('node_left')
			
			# next, deal with current and all the other related stuff
			# if current is a node
			if current.tile.substr(0, 4) == 'node':
				if current.path.size() > 1:
					for button in hovered_tile.path:
						reset_button(button)
						
				hovered_tile.path = origin.path.duplicate()
				hovered_tile.path.invert()
				origin.origin = hovered_tile
				hovered_tile.origin = origin
					
				if current == prev.adjacent['up']:
					current.set_tile('node_down')
				elif current == prev.adjacent['right']:
					current.set_tile('node_left')
				elif current == prev.adjacent['down']:
					current.set_tile('node_up')
				elif current == prev.adjacent['left']:
					current.set_tile('node_right')
				
				get_parent().connected_node()
					
			# if current is an end 
			elif current.tile.substr(0, 3) == 'end':
				var remote_node = current.origin
				origin.origin = remote_node
				remote_node.origin = origin
				
				var new_path = remote_node.path.duplicate()
				new_path.invert()
				new_path.pop_front()
				var next = new_path[0]
				new_path = origin.path + new_path
				origin.path = new_path.duplicate()
				new_path.invert()
				remote_node.path = new_path.duplicate()
				
				if next == current.adjacent['up'] and current == prev.adjacent['up']\
				or next == current.adjacent['down'] and current == prev.adjacent['down']:
					current.set_tile('wire_up')
					
				if next == current.adjacent['left'] and current == prev.adjacent['left']\
				or next == current.adjacent['right'] and current == prev.adjacent['right']:
					current.set_tile('wire_right')
					
				if next == current.adjacent['up'] and current == prev.adjacent['left']\
				or next == current.adjacent['right'] and current == prev.adjacent['down']:
					current.set_tile('wire_up_right')
					
				if next == current.adjacent['down'] and current == prev.adjacent['left']\
				or next == current.adjacent['right'] and current == prev.adjacent['up']:
					current.set_tile('wire_down_right')
					
				if next == current.adjacent['left'] and current == prev.adjacent['up']\
				or next == current.adjacent['down'] and current == prev.adjacent['right']:
					current.set_tile('wire_down_left')
					
				if next == current.adjacent['up'] and current == prev.adjacent['right']\
				or next == current.adjacent['left'] and current == prev.adjacent['down']:
					current.set_tile('wire_up_left')
				
				release_wire()
				get_parent().connected_node()
			
			# if current is blank
			elif current.tile == 'blank':
			
				hovered_tile.origin = origin
				
				if current == prev.adjacent['up']:
					current.set_tile('end_up')
				elif current == prev.adjacent['right']:
					current.set_tile('end_right')
				elif current == prev.adjacent['down']:
					current.set_tile('end_down')
				elif current == prev.adjacent['left']:
					current.set_tile('end_left')
			
		# if they're pulling a wire back
		elif hovered_tile == prev:
			reset_button(current)
				
			origin.origin = null
			origin.path.pop_back()
			
			# either the path is size 2 or more...
			if origin.path.size() >= 2:
				current = origin.path[origin.path.size() - 1]
				prev = origin.path[origin.path.size() - 2]
			
				if current == prev.adjacent['up']:
					current.set_tile('end_up')
				elif current == prev.adjacent['right']:
					current.set_tile('end_right')
				elif current == prev.adjacent['down']:
					current.set_tile('end_down')
				elif current == prev.adjacent['left']:
					current.set_tile('end_left')
			
			# or you erased the entire wire
			else:
				origin.set_tile('node')
			

func mouse_exited(button):
	if button == hovered_tile:
		hovered_tile = null
		
func _input(event):
	if event is InputEventMouseButton:
		# if they clicked on a clickable tile
		if event.pressed and hovered_tile and hovered_tile.tile in clickable:
			# if they clicked on a node
			if hovered_tile.tile.substr(0, 4) == 'node':
				if hovered_tile.path.size() > 1:
					for button in hovered_tile.path:
						reset_button(button)
				origin = hovered_tile
				
			# if they clicked on the end of a path
			elif hovered_tile.origin:
				origin = hovered_tile.origin
						
			get_tree().set_input_as_handled()
			
			# temporarily override all the cursor shapes with CURSOR_MOVE
			Input.set_default_cursor_shape(Input.CURSOR_MOVE)
			for button in get_children():
				button.mouse_default_cursor_shape = Input.CURSOR_MOVE
		
		# if they previously clicked on a clickable tile, then let go
		elif not event.pressed and origin:
			release_wire()