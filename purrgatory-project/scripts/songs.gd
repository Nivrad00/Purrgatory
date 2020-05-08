extends Node

var songs = {
	'lick1': {
		'tempo': 0.05,
		'left': 'gfedcvbagfedc',
		'right': ''
	},
	
	'lick2': { 'tempo': 0.5, 'left': 'v[cge]', 'right': '[cge]' },
	
	'lick3': { 
		'tempo': 0.2, 
		'left': 'v[cgd]2v[g^dcva]3[a^fc#d]4[va^fcd]2[va^fcd]3', 
		'right': '[cge]2[f^cvba]3[deagf]4[deagf]2[deagf]3',
		'return': 'piano_intro3'
	},

	'fur_elise1': {
		'tempo': 0.06,
		'right': '^e6 d#7 e6 d#6 e6 va#9 r5 ^c#9 r4',
		'left':  '',
		'return': 'piano_intro3a'
	},
	
	'fur_elise2': {
		'tempo': 0.06,
		'right': '^e4 d#4 e4 d#4 e6 vb9 r9 ^ d9 r9 r9 r4',
		'left':  '',
		'return': 'piano_intro3b'
	},
	
	'fur_elise3': {
		'tempo': 0.06,
		'right': '^e4 d#4 e4 d#4 e6 vb8 ^d9 c9 r9 va4 r9 r9     c9 e8 g9 r9 g#9 r9 r9 r3',
		'left':  'r9 r9 r9 r9 r9 r9 r3               vva9 ^e6 a4',
		'return': 'piano_intro3c'
	},
	
	'megalovania': {
		'tempo': 0.15,
		'left': '',
		'right': 'r16[e8b4g8]' +\
				 'vee^e2vb3a#2a2g2ega' +\
				 'dd^e2vb3a#2a2g2ega' +\
				 'c#c#^e2vb3a#2a2g2ega' +\
				 'cc^e2vb3a#1d1a2g2ega[e8b4g8]'
	},
	
	'heart_tutorial': {
		'tempo': 0.2,
		'right': '',
		'left':  'c3 c3 c6 r2 c v b2 a b2 ^ c d3' +\
		         'e3 e3 e6 r2 e   d2 c d2   e f3' +\
				 'g6    c6 r2 a   g2 f e3     d3' +\
				 'c6',
		'return': 'piano_heart3'
		
	},
	
	'heart_performance': {
		'tempo': 0.2,
		'right': '',
		'left':  'r4 vc2 c e2 e va2 a ^c2 c vf2 f a2 a g2 g b2 b^' +\
					 'c2 c e2 e va2 a ^c2 c vf2 f a2 a g2 g b2 b^' +\
					 'c2 c e2 e va2 a ^c2 c vf2 f a2 a g2 g b2 b^' +\
					 'c2 c e2 e va2 a ^c2 c vf2 f a2 a g2 g b2 b^ c3',
		'return': 'piano_heart6'
	},
	
	'fur_elise_full': {
		'tempo': 0.3,
		'right': '^e d# e d# e vb ^d c va r2   c e a b r2    e g# b ^c r2   ve' +\
				 '^e d# e d# e vb ^d c va r2   c e a b r2    e ^c vb a',
		'left':  'r8                vva ^e a r3   ve ^e g# r3       va ^e a r' +\
				 'r8                 va ^e a r3   ve ^e g# r3       va',
		'return': 'piano_intro3a'
	},
	
}