extends Node

var blocks = {
	'cool_text': {
		'speaker': '',
		'sprites': [],
		'text': 'You decide to approach the pony and the dragon.',
		'branches': [],
		'states': [],
		'next': 'cooler_text'
	},
	'cooler_text': {
		'speaker': 'Twilight',
		'sprites': ['twilight', 'qibli'],
		'text': 'Oh my, Qibli, you\'re looking quite handsome today!',
		'branches': [],
		'states': [],
		'next': 'even_cooler_text'
	},
	'even_cooler_text': {
		'speaker': 'Qibli',
		'sprites': ['twilight', 'qibli'],
		'text': 'I\'m sorry Twilight, but my heart belongs to another!',
		'branches': [],
		'states': [],
		'next': '0'
	},
	'0': {
		'speaker': 'Twilight',
		'sprites': ['twilight'],
		'text': 'Qibli, nooooooooo!!',
		'branches': [],
		'states': [],
		'next': '1'
	},
	'1': {
		'speaker': 'Twilight',
		'sprites': ['twilight'],
		'text': 'Come back my love!!!',
		'branches': [],
		'states': [],
		'next': '2'
	},
	'2': {
		'speaker': '',
		'sprites': [],
		'text': 'The pony runs after the drgaon, leaving you alone.',
		'branches': [],
		'states': [],
		'next': 'end'
	},
	'end': null,
	'whoops': {
		'speaker': '',
		'sprites': [],
		'text': 'The pony and the dragon are nowhere to be seen.',
		'branches': [],
		'states': [],
		'next': 'end'
	}
}

func get_state(key, dict):
	if key in dict:
		return dict[key]
	else:
		dict[key] = false
		return false
		
func get_block(label, state):
	if label == '2':
		state['met_twi_and_qibli'] = true
	if get_state('met_twi_and_qibli', state) == true and label == 'cool_text':
		return blocks['whoops']
	else:
		return blocks[label]