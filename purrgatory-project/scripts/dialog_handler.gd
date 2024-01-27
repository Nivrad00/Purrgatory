extends Node

var blocks = {}	

var placeholder_block = {
	'label': 'placeholder',
	'speaker': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
	'sprites': [],
	'text': [
		'(text block not found)', 
		'(text block not found)', 
		'(text block not found)', 
		'(text block not found)', 
		'(text block not found)', 
		'(text block not found)', 
		'(text block not found)', 
		'(text block not found)', 
		'(text block not found)', 
		'(text block not found)', 
		'(text block not found)'
	],
	'states': [],
	'next': null,
	'choices': [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
}
# i've just put a bunch of extra copies so that it doesn't break if there's too
# many languages

func _ready():
	var i = 0
	var last_block = null
	
	var tokenizer = EvalTokenizer.new()
	var true_tokens = tokenizer.tokenize('true')
	var true_tree = EvalTree.new(true_tokens)
	var true_evaluator = EvalEvaluate.new(true_tree.get_tree())
	
	# check to make sure translations are all the same length
	var script_length = get_child(0).raw_blocks.size()
	for node in get_children():
		if node.raw_blocks.size() != script_length:
			print("error: translated script is not the same length as original script")
			return
	
	# loop through all lines
	for block_index in range(script_length):
		var original_data = get_child(0).raw_blocks[block_index]
		var all_data = []
		for node in get_children():
			all_data.append(node.raw_blocks[block_index])
		
		# construct a block from scratch
		var block = {
		}
			
		# make sure labels match up between translations
		for data in all_data:
			if data[0] != original_data[0]:
				print("error: label " + original_data[0] + " in original script does not match translated label " + data[0])
				return
				
		# choose label
		var label
		if original_data[0] == '':
			label = str(i)
			i += 1
		else:
			label = original_data[0]
		
		block['label'] = label
		blocks[label] = block
		
		# set current block to be the "next" of the previous block, if need be
		if last_block and typeof(last_block['next']) == TYPE_STRING and last_block['next'] == '_next':
			last_block['next'] = [label]
		
		# set speaker
		block['speaker'] = [] # each element in speaker array represents a different language
		for k in range(all_data.size()):
			var data = all_data[k]
			if data[1] == '':
				# each block needs to have the speaker defined so that the player can swap between languages fluidly
				# rather than just having the speaker be null, which signals to the UI to not change the speaker
				# EXCEPT. for choices. some choices need to have null speaker bc there might be multiple paths (with different speakers)
				#   that lead to the same choice, in which case the speaker from before the choice still needs to show
				# unfortunately this means that if you change language while on a choice, the speaker (and dialog) wont get translated
				#   until you move to the next block, but i dont care enough to fix this
				if typeof(data[8]) != TYPE_ARRAY and last_block and typeof(last_block['speaker'][k]) == TYPE_STRING:
					block['speaker'].append(last_block['speaker'][k])
				else:
					block['speaker'].append(null)
			elif data[1] == '_none':
				block['speaker'].append('')
			else:
				block['speaker'].append(data[1])
		
		# set sprites
		if typeof(original_data[2]) == TYPE_STRING and original_data[2] == '':
			block['sprites'] = null
		elif typeof(original_data[2]) == TYPE_STRING and original_data[2] == '_none':
			block['sprites'] = []
		elif typeof(original_data[2]) == TYPE_STRING:
			block['sprites'] = [original_data[2]]
		else:
			block['sprites'] = original_data[2]
		
		# set text
		block['text'] = [] # etc
		for data in all_data:
			if data[3] == '':
				block['text'].append(null)
			elif data[3] == '_none':
				block['text'].append('')
			else:
				block['text'].append(data[3])
				
		# set states
		if typeof(original_data[4]) == TYPE_STRING and original_data[4] == '':
			block['states'] = []
		elif typeof(original_data[4]) == TYPE_STRING:
			block['states'] = [[original_data[4], true]]
		else:
			block['states'] = original_data[4]
		
		# set conditions
		if typeof(original_data[5]) == TYPE_STRING and original_data[5] == '':
			block['conditions'] = [true_evaluator]
		elif typeof(original_data[5]) == TYPE_STRING:
			var tokens = tokenizer.tokenize(original_data[5])
			var tree = EvalTree.new(tokens)
			var evaluator = EvalEvaluate.new(tree.get_tree())
			block['conditions'] = [evaluator]
		else:
			block['conditions'] = []
			for condition in original_data[5]:
				var tokens = tokenizer.tokenize(condition)
				var tree = EvalTree.new(tokens)
				var evaluator = EvalEvaluate.new(tree.get_tree())
				block['conditions'].append(evaluator)
		
		# set next
		if typeof(original_data[6]) == TYPE_STRING and original_data[6] == '':
			block['next'] = '_next'
		elif typeof(original_data[6]) == TYPE_STRING and original_data[6] == 'null':
			block['next'] = [null]
		elif typeof(original_data[6]) == TYPE_STRING:
			block['next'] = [original_data[6]]
		else:
			block['next'] = original_data[6]
		
		# set choices
		block['choices'] = [] # as with text and speaker
		for data in all_data:
			var current_choices = []
			if typeof(data[8]) == TYPE_ARRAY and typeof(data[9]) == TYPE_ARRAY:
				for j in range(data[8].size()):
					current_choices.append([data[8][j], data[9][j]])
			block['choices'].append(current_choices)
			
			# make sure to check if the number of choices is mismatched
			if current_choices.size() != block['choices'][0].size():
				print("error: number of choices at block index " + str(block_index) + " is inconsistent between translations")
				return
	
		# set choice conditions
		var new_array = []
		if typeof(original_data[7]) == TYPE_STRING and original_data[7] == '':
			for _j in range(block['choices'][0].size()):
				new_array.append(true_evaluator)
		else:
			for j in range(block['choices'][0].size()):
				var tokens = tokenizer.tokenize(original_data[7][j])
				var tree = EvalTree.new(tokens)
				var evaluator = EvalEvaluate.new(tree.get_tree())
				new_array.append(evaluator)
		block['choice_conditions'] = new_array
			
		last_block = block
		
func get_block(label, state):
	if label == null:
		return null
	# print(label)
	
	if !(label in blocks):
		return placeholder_block
	var block = blocks[label]
	
	# deal with empty blocks (choice blocks)
	# note: you can't modify the state with an empty block
	while block['text'][0] == '_pass':
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
			
		# print(next_label)
		block = blocks[next_label]
		
	var proc_block = {}
	proc_block['label'] = block['label']
	proc_block['speaker'] = block['speaker']
	proc_block['sprites'] = block['sprites']
	proc_block['text'] = block['text']
	proc_block['states'] = block['states']
	
	proc_block['choices'] = []
	for lang_choices in block['choices']: # iterate through all languages
		var proc_lang_choices = []
		for i in range(lang_choices.size()): # iterate through all choices in that language
			if block['choice_conditions'][i].evaluate(state):
				proc_lang_choices.append(lang_choices[i])
		if proc_lang_choices.size() > 4:
			proc_lang_choices.resize(4)
		proc_block['choices'].append(proc_lang_choices)
	
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
