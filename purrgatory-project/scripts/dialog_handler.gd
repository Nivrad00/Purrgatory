extends Node

var blocks = {}	

var placeholder_block = {
	'label': 'placeholder',
	'speaker': '',
	'sprites': [],
	'text': '(text block not found)',
	'states': [],
	'next': null,
	'choices': []
}

func _ready():
	var i = 0
	var last_block = null
	
	var tokenizer = EvalTokenizer.new()
	var true_tokens = tokenizer.tokenize('true')
	var true_tree = EvalTree.new(true_tokens)
	var true_evaluator = EvalEvaluate.new(true_tree.get_tree())
	
	for child in get_children():
		print(child.name)
		for data in child.raw_blocks:
			var block = {}
			
			var label
			if data[0] == '':
				label = str(i)
				i += 1
			else:
				label = data[0]
			
			block['label'] = label
			blocks[label] = block
			if last_block and typeof(last_block['next']) == TYPE_STRING and last_block['next'] == '_next':
				last_block['next'] = [label]
				
			if data[1] == '':
				block['speaker'] = null
			elif data[1] == '_none':
				block['speaker'] = ''
			else:
				block['speaker'] = data[1]
			
			if typeof(data[2]) == TYPE_STRING and data[2] == '':
				block['sprites'] = null
			elif typeof(data[2]) == TYPE_STRING and data[2] == '_none':
				block['sprites'] = []
			elif typeof(data[2]) == TYPE_STRING:
				block['sprites'] = [data[2]]
			else:
				block['sprites'] = data[2]
				
			if data[3] == '':
				block['text'] = null
			elif data[3] == '_none':
				block['text'] = ''
			else:
				block['text'] = data[3]
				
			if typeof(data[4]) == TYPE_STRING and data[4] == '':
				block['states'] = []
			elif typeof(data[4]) == TYPE_STRING:
				block['states'] = [[data[4], true]]
			else:
				block['states'] = data[4]
			
			if typeof(data[5]) == TYPE_STRING and data[5] == '':
				block['conditions'] = [true_evaluator]
			elif typeof(data[5]) == TYPE_STRING:
				var tokens = tokenizer.tokenize(data[5])
				var tree = EvalTree.new(tokens)
				var evaluator = EvalEvaluate.new(tree.get_tree())
				block['conditions'] = [evaluator]
			else:
				block['conditions'] = []
				for condition in data[5]:
					var tokens = tokenizer.tokenize(condition)
					var tree = EvalTree.new(tokens)
					var evaluator = EvalEvaluate.new(tree.get_tree())
					block['conditions'].append(evaluator)
					
			if typeof(data[6]) == TYPE_STRING and data[6] == '':
				block['next'] = '_next'
			elif typeof(data[6]) == TYPE_STRING and data[6] == 'null':
				block['next'] = [null]
			elif typeof(data[6]) == TYPE_STRING:
				block['next'] = [data[6]]
			else:
				block['next'] = data[6]
			
			block['choices'] = []
			if typeof(data[8]) == TYPE_ARRAY and typeof(data[9]) == TYPE_ARRAY:
				for i in range(data[8].size()):
					block['choices'].append([data[8][i], data[9][i]])
					
			var new_array = []
			if typeof(data[7]) == TYPE_STRING and data[7] == '':
				for i in range(block['choices'].size()):
					new_array.append(true_evaluator)
			else:
				for i in range(block['choices'].size()):
					var tokens = tokenizer.tokenize(data[7][i])
					var tree = EvalTree.new(tokens)
					var evaluator = EvalEvaluate.new(tree.get_tree())
					new_array.append(evaluator)
			block['choice_conditions'] = new_array
				
			last_block = block
		
func get_block(label, state):
	if label == null:
		return null
	print(label)
	
	if !(label in blocks):
		return placeholder_block
	var block = blocks[label]
	
	# deal with empty blocks (choice blocks)
	# note: you can't modify the state with an empty block
	while block['text'] == '_pass':
		var next_label
		
		if block['next'][0] == '_rand':
			var size = block['next'].size()
			next_label = block['next'][(randi() % (size - 1)) + 1]
		else:
			var i = 0
			while i < block['conditions'].size():
				if block['conditions'][i].evaluate(state):
					break
				i += 1
			next_label = block['next'][i]
				
		if next_label == null:
			return null
			
		print(next_label)
		block = blocks[next_label]
		
	var proc_block = {}
	proc_block['label'] = block['label']
	proc_block['speaker'] = block['speaker']
	proc_block['sprites'] = block['sprites']
	proc_block['text'] = block['text']
	proc_block['states'] = block['states']
	
	var proc_choices = []
	for i in range(block['choices'].size()):
		if block['choice_conditions'][i].evaluate(state):
			proc_choices.append(block['choices'][i])
	proc_block['choices'] = proc_choices
	
	var next_label
	
	if block['next'][0] == '_rand':
		var size = block['next'].size()
		next_label = block['next'][(randi() % (size - 1)) + 1]
	else:
		var i = 0
		while i < block['conditions'].size():
			if block['conditions'][i].evaluate(state):
				break
			i += 1
		next_label = block['next'][i]
				
	proc_block['next'] = next_label
	
	return proc_block