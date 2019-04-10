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
		'text': 'You see Twilight looking sad.',
		'branches': [],
		'states': [],
		'next': '3'
	},
	'3': {
		'speaker': 'Twilight',
		'sprites': ['twilight'],
		'text': 'Player... do you think Qibli will ever love me?',
		'branches': [],
		'states': [],
		'next': '4'
	},
	'4': {
		'speaker': 'Twilight',
		'sprites': ['twilight'],
		'text': 'Player... do you think Qibli will ever love me?',
		'branches': [['Yes', '5'], ['No', '8'], ['Holy shit a talking pony', '10']],
		'states': [],
		'next': null
	},
	'5': {
		'speaker': 'You',
		'sprites': ['twilight'],
		'text': 'Yes... It\'s just that Qibli thinks he\'s not good enough for you... Be gentle with him.',
		'branches': [],
		'states': [],
		'next': '6'
	},
	'6': {
		'speaker': 'Twilight',
		'sprites': ['twilight'],
		'text': 'You\'re right, Player. Thank you so much. I\'m going to go smooch that dragon right now.',
		'branches': [],
		'states': [],
		'next': '7'
	},
	'7': {
		'speaker': '',
		'sprites': [],
		'text': 'Twilight runs off to find Qibli.',
		'branches': [],
		'states': [],
		'next': 'end'
	},
	'8': {
		'speaker': 'Player',
		'sprites': ['twilight'],
		'text': 'No, not really.',
		'branches': [],
		'states': [],
		'next': '9'
	},
	'9': {
		'speaker': 'Twilight',
		'sprites': ['twilight'],
		'text': 'Fuck you, Player! We were meant to be together!',
		'branches': [],
		'states': [],
		'next': '7'
	},
	'10': {
		'speaker': 'Twilight',
		'sprites': ['twilight'],
		'text': 'Neigh',
		'branches': [],
		'states': [],
		'next': 'end'
	},
	'hot_sexy_makeout_session': {
		'speaker': '',
		'sprites': [],
		'text': 'You see Twilight and Qibli making out passionately in the distance.',
		'branches': [],
		'states': [],
		'next': '11'
	},
	'11': {
		'speaker': '',
		'sprites': [],
		'text': 'Maybe you should leave them alone for now.',
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
	if label == '4':
		state['advised_twi'] = true
	if get_state('advised_twi', state) == true and label == 'cool_text':
		return blocks['hot_sexy_makeout_session']
	if get_state('met_twi_and_qibli', state) == true and label == 'cool_text':
		return blocks['whoops']
	else:
		return blocks[label]