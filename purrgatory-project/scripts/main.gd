extends Node

var loader
var fade_out = false

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