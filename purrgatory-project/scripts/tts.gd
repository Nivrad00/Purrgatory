extends Node

const TTSDriver = preload("res://TTSDriver.gdns")
var to_speak = ''
var exit_thread = false
var thread
var semaphore
var mutex

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
	mutex = Mutex.new()
	semaphore = Semaphore.new()
	thread = Thread.new()
	thread.start(self, '_tts_thread')
	
	# for some reason... this make thes threaded version work. why. idk
	var tts = TTSDriver.new()
	tts.speak('', false)
	
	# tts.set_voice(tts.get_voices()[1]['name'])
	# this is just to change the voice to zira on my machine bc i like it better
	# i need to remember to remove this later dlfkgjglkd

func _tts_thread(_userdata):
	var tts = TTSDriver.new()
	while true:
		semaphore.wait()
		
		mutex.lock()
		var should_exit = exit_thread # Protect with Mutex.
		mutex.unlock()
		
		if should_exit:
			break
		
		mutex.lock()
		var text = to_speak
		to_speak = ''
		mutex.unlock()
		
		if text == '_stop_tts':
			tts.stop()
		else:
			tts.speak(text, false)
	
func speak(text):
	if !enabled:
		return
			
	for word in pronunciation:
		text = text.replacen(word[0], word[1])
	
	if text != '':
		mutex.lock()
		to_speak = text
		mutex.unlock()
		semaphore.post()

func stop():
	mutex.lock()
	to_speak = '_stop_tts' # indicates stop
	mutex.unlock()
	semaphore.post()

func toggle_voicing(_enabled):
	enabled = _enabled
	if !enabled:
		stop()

func _exit_tree():
	mutex.lock()
	exit_thread = true
	mutex.unlock()
	semaphore.post()
	
	thread.wait_to_finish()