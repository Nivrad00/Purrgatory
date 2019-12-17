extends Node

const TTSDriver = preload("res://TTSDriver.gdns")
var tts = TTSDriver.new()

var pronunciation = [
	['purrgatory', 'purgatory'],
	['[i]', ''],
	['[//i]', ''],
	['):<', ', frowny face,'],
	[';;', ', crying face,'],
	['(:', ', smiley face,']
]

var replacements = [
	['…', 'dot dot dot'],
	['...', 'dot dot dot'],
	['•••', 'dot dot dot']
]

var enabled = false

func _ready():
	tts.set_voice(tts.get_voices()[1]['name'])
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