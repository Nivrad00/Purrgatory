extends Node

const TTSDriver = preload("res://TTSDriver.gdns")
var tts

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
	[':3c', ', cat face,'],
	[';3333', ', winking cat face,'],
	[';3', ', winking cat face,'],
	['^^', 'happy face'],
	['lucifur', 'lucifer'],
	['tori', 'tory']
]

var enabled = false

func _ready():
	tts = TTSDriver.new()
	
func speak(text):
	yield(get_tree(), 'idle_frame')
	
	if !enabled:
		return
			
	for word in pronunciation:
		text = text.replacen(word[0], word[1])
	
	if text != '':
		tts.speak(text, false)

func stop():
	yield(get_tree(), 'idle_frame')
	tts.stop()

func toggle_voicing(_enabled):
	enabled = _enabled
	if !enabled:
		stop()

func change_voice_speed(speed):
	tts.set_rate(int(speed))