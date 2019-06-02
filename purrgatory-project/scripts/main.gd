extends Node

var fade_out = false
var fade_out_loading = false
var game_path = 'res://scenes/game.tscn'

func _ready():
	$loader.start()
	$loader.queue_resource(game_path)
	set_process(true)
	
func finish_loading(node):
	add_child(node.instance())
	$game.hide()
	$loading/ding.play()
	$loading/loading_text.set_text('ready!\r\nclick to continue')

func _on_click_to_continue_pressed():
	fade_out_loading = true
	
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
	if has_node('loader'):
		if $loader.is_ready(game_path):
			var scene = $loader.get_resource(game_path)
			finish_loading(scene)
			$loader.queue_free()
				
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
			
	if fade_out_loading:
		var a = $loading.get_modulate().a
		if a == 0:
			$delay_timer.start()
			$loading.hide()
			fade_out_loading = false
			yield($delay_timer, 'timeout')
			$loading.hide()
			$main_menu.show()
			$main_menu/audio.play()
		else:
			a = max(a - 2 * delta, 0)
			$loading.set_modulate(Color(1, 1, 1, a))