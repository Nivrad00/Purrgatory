extends Node

const TTSDriver = preload("res://TTSDriver.gdns")
var tts = TTSDriver.new()

var pronunciation = [
	['purrgatory', 'purgatory'],
	['[i]', ''],
	['[/i]', ''],
	['purrgatory', 'purgatory'],
	['[i]', ''],
	['[/i]', ''],
	['):<', ', angry face,'],
	['>:(', ', angry face,'],
	['(:', ', smiley face,'],
	[':)', ', smiley face,'],
	['(;;;;;;;', ', winky face,'],
	['(;;;;', ', winky face,'],
	['(;;;', ', winky face,'],
	['(;;', ', winky face,'],
	[';;', ', crying face,'],
	['(;', ', winky face,'],
	[';)', ', winky face,'],
	[':P', ', face with tongue out,'],
	[':3', ', cat face,'],
	[':C', ', sad face,'],
	[':c', ', sad face,'],
	['):', ', sad face,'],
	[':(', ', sad face,'],
	[':/', ', meh face,'],
	[':\\', ', meh face,'],
	[':3', ', cat face,'],
	[';3333', ', winking cat face,'],
	[';3', ', winking cat face,'],
	['^^', 'happy face']
]

var replacements = [
	['…', 'dot dot dot'],
	['...', 'dot dot dot'],
	['•••', 'dot dot dot']
]

var enabled = false

func _ready():
	pass
	# tts.set_voice(tts.get_voices()[1]['name'])
	# this is just to change the voice to zira on my machine bc i like it better
	# i need to remember to remove this later dlfkgjglkd

func speak(text):
	if !enabled:
		return
		
	for word in replacements:
		if text == word[0]:
			tts.speak(word[1], false)
			return
			
	for word in pronunciation:
		text = text.replacen(word[0], word[1])
		
	tts.speak(text, false)

func stop():
	tts.stop()

func toggle_voicing(_enabled):
	enabled = _enabled
	if !enabled:
		tts.stop()