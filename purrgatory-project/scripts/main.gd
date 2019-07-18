extends Node

var fade_out = false
var fade_out_loading = false
var game_path = 'res://scenes/game.tscn'
var loaded_flag = false

func _ready():
	$loader.start()
	$loader.queue_resource(game_path)
	set_process(true)
	check_save()

func check_save():
	var save_game = File.new()
	if save_game.file_exists("user://save1.save"):
		$main_menu/buttons/continue/x.hide()
		$main_menu/buttons/continue.disabled = false
	else:
		$main_menu/buttons/continue/x.show()
		$main_menu/buttons/continue.disabled = true
	
func finish_loading(node):
	add_child(node.instance())
	$game.connect('return_to_main', self, 'return_to_main')
	$game.hide()
	$loading/loading_text.set_text('ready!\r\nclick to continue')
	loaded_flag = true

func return_to_main():
	$game.hide()
	$main_menu.show()
	$main_menu/audio.play()
	check_save()
	
func _on_click_to_continue_pressed():
	print('sdfkj')
	fade_out_loading = true
	
func _on_start_pressed():
	fade_out = true

func _on_continue_pressed():
	$game.load_game()
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
	if loaded_flag:
		$loading/click_to_continue.show()
		loaded_flag = false
		
	if has_node('loader'):
		if $loader.is_ready(game_path):
			var scene = $loader.get_resource(game_path)
			finish_loading(scene)
			$loader.queue_free()
				
	if fade_out:
		var a = $main_menu.get_modulate().a
		if a == 0:
			$delay_timer.start()
			fade_out = false
			$main_menu/audio.stop()
			$main_menu/audio.volume_db = -3
			yield($delay_timer, 'timeout')
			
			$main_menu.hide()
			$main_menu.set_modulate(Color(1, 1, 1, 1))
			$game.show()
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