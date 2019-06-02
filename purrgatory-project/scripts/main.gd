extends Node

var wait_frames = 1
var loader
var fade_out = false

func _ready():
	var i = 0
	loader = ResourceLoader.load_interactive('res://scenes/game.tscn')
	set_process(true)
	
func finish_loading(node):
	add_child(node)
	$game.hide()
	$loading.hide()
	$main_menu.show()
	$main_menu/audio.play()
	loader = null
	
func _on_start_pressed():
	fade_out = true

func _on_credits_pressed():
	$main_menu.hide()
	$credits.show()
	
func _on_exit_pressed():
	get_tree().quit()

func _on_back_pressed():
	$credits.hide()
	$main_menu.show()

func _process(delta):
	if wait_frames > 0:
		wait_frames -= 1
		return
		
	if loader:
		var t = OS.get_ticks_msec()
		while OS.get_ticks_msec() < t + 100:
			var err = loader.poll()
			if err == ERR_FILE_EOF:
				var node = loader.get_resource().instance()
				finish_loading(node)
				break
				
	if fade_out:
		var a = $main_menu.get_modulate().a
		if a == 0:
			$delay_timer.start()
			$main_menu.hide()
			fade_out = false
			yield($delay_timer, 'timeout')
			$game.show()
			$main_menu/audio.stop()
		else:
			a = max(a - 2 * delta, 0)
			$main_menu/audio.volume_db = $main_menu/audio.volume_db - 40 * delta
			$main_menu.set_modulate(Color(1, 1, 1, a))