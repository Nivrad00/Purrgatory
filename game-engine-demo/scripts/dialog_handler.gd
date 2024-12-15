extends Node

var blocks = {
	'cool_text': {
		'speaker': '',
		'sprites': ['twilight', 'qibli'],
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
		'next': 'end'
	},
	'end': null,
	'whoops': {
		'speaker': '',
		'sprites': ['twilight'],
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
		'branches': [['Yes he does love you', '5'], ['No', '8'], ['Holy shit a talking pony', '10']],
		'states': [],
		'next': null
	},
	'4b': {
		'speaker': 'Twilight',
		'sprites': ['twilight'],
		'text': 'Player... do you think Qibli will ever love me?',
		'branches': [['idk', 'idk'], ['Holy shit a talking pony', '10']],
		'states': [],
		'next': null
	},
	'idk': {
		'speaker': 'You',
		'sprites': ['twilight'],
		'text': 'idk',
		'branches': [],
		'states': [],
		'next': 'idk2'
	},
	'idk2': {
		'speaker': 'Twilight',
		'sprites': ['twilight'],
		'text': 'Well thanks for nothing, dickhead',
		'branches': [],
		'states': [],
		'next': 'end'
	},
	'5': {
		'speaker': 'You',
		'sprites': ['twilight'],
		'text': 'Yes... It\'s just that Qibli thinks he\'s not good enough for you...',
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
		'text': 'You see Twilight and Qibli making out passionately.',
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
	},
	'talk_to_qibli': {
		'speaker': 'You',
		'sprites': ['qibli'],
		'text': 'Qibli... don\'t you love her?',
		'branches': [],
		'states': [],
		'next': '12'
	},
	'12': {
		'speaker': 'Qibli',
		'sprites': ['qibli'],
		'text': 'I do... Twilight Sparkle is the love of my life... but she can do so much better than me...',
		'branches': [],
		'states': [],
		'next': '13'
	},
	'13': {
		'speaker': 'Qibli',
		'sprites': ['qibli'],
		'text': 'It\'s better to let her think I love another...',
		'branches': [],
		'states': [],
		'next': '12b'
	},
	'12b': {
		'speaker': 'You',
		'sprites': ['qibli'],
		'text': 'I see',
		'branches': [],
		'states': [],
		'next': 'end'
	},
	'sigh': {
		'speaker': '',
		'sprites': ['qibli'],
		'text': 'Qibli sighs sexily and sadly',
		'branches': [],
		'states': [],
		'next': 'end'
	}
		
}

func get_state(key, dict):
	if key in dict:
		return dict[key]
	else:
		return false
		
func get_block(label, state):
	if label == 'cool_text':
		state['talking_to_twi'] = true
	if (label == 'talk_to_qibli' and not get_state('advised_twi', state)) or label == 'cool_text':
		state['talking_to_qibli'] = true
	if label == 'end':
		state['talking_to_twi'] = false
		state['talking_to_qibli'] = false
		
	if label == '1':
		state['met_twi_and_qibli'] = true
	if label == '13':
		state['talked_to_qibli'] = true
		
	if get_state('met_twi_and_qibli', state) and label == 'cool_text':
		return blocks['whoops']
	if get_state('advised_twi', state) and label == 'talk_to_qibli':
		return blocks['hot_sexy_makeout_session']
	if get_state('talked_to_qibli', state) and label == 'talk_to_qibli':
		return blocks['sigh']
		
	if label == '4':
		if get_state('talked_to_qibli', state):
			state['advised_twi'] = true
			return blocks['4']
		else:
			return blocks['4b']
			
	else:
		return blocks[label]
