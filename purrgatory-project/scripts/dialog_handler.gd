extends Node

var blocks = {
	
}	

func _ready():
	var i = 0
	var last_block = null
	
	for child in get_children():
		for data in child.raw_blocks:
			var block = {}
			
			var label
			if data[0] == '':
				label = str(i)
				i += 1
			else:
				label = data[0]
		
			blocks[label] = block
			if last_block and typeof(last_block['next']) == TYPE_STRING and last_block['next'] == '_next':
				last_block['next'] = [label]
				
			if data[1] == '':
				block['speaker'] = last_block['speaker']
			elif data[1] == '_none':
				block['speaker'] = ''
			else:
				block['speaker'] = data[1]
			
			if typeof(data[2]) == TYPE_STRING and data[2] == '':
				block['sprites'] = last_block['sprites']
			elif typeof(data[2]) == TYPE_STRING and data[2] == '_none':
				block['sprites'] = []
			elif typeof(data[2]) == TYPE_STRING:
				block['sprites'] = [data[2]]
			else:
				block['sprites'] = data[2]
				
			if data[3] == '':
				block['text'] = last_block['text']
			elif data[3] == '_none':
				block['text'] = ''
			else:
				block['text'] = data[3]
				
			if typeof(data[4]) == TYPE_STRING and data[4] == '':
				block['choices'] = []
			else:
				block['choices'] = data[4]
				
			if typeof(data[5]) == TYPE_STRING and data[5] == '':
				block['states'] = []
			elif typeof(data[5]) == TYPE_STRING:
				block['states'] = [[data[5], true]]
			else:
				block['states'] = data[5]
				
			if typeof(data[6]) == TYPE_STRING and data[6] == '':
				block['conditions'] = []
			elif typeof(data[6]) == TYPE_STRING:
				block['conditions'] = [data[6]]
			else:
				block['conditions'] = data[6]
				
			if typeof(data[7]) == TYPE_STRING and data[7] == '':
				block['next'] = '_next'
			elif typeof(data[7]) == TYPE_STRING and data[7] == 'null':
				block['next'] = [null]
			elif typeof(data[7]) == TYPE_STRING:
				block['next'] = [data[7]]
			else:
				block['next'] = data[7]
			
			last_block = block

func get_state(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false
		
func get_block(label, state):
	if label == null:
		return null
	print(label)
	var block = blocks[label]
	
	# deal with empty blocks (choice blocks)
	# note: you can't modify the state with an empty block
	while block['text'] == '_pass':
		var i = 0
		for key in block.conditions:
			if not get_state(key, state):
				i = 1
		if block['next'][i] == null:
			return null
		print(block['next'][i])
		block = blocks[block['next'][i]]
		
	var proc_block = {}
	proc_block['speaker'] = block['speaker']
	proc_block['sprites'] = block['sprites']
	proc_block['text'] = block['text']
	proc_block['choices'] = block['choices']
	proc_block['states'] = block['states']
	
	var i = 0
	for key in block.conditions:
		if not get_state(key, state):
			i = 1
	proc_block['next'] = block['next'][i]
	
	return proc_block