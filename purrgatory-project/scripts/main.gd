extends Node

# null when not fading out
# -1 when fading out to start a new game
# n when fading out to load save file n
var fade_out = null
var fade_out_loading = false
var game_path = 'res://scenes/game.tscn'
var loaded_flag = false

func _ready():
	$loader.start()
	$loader.queue_resource(game_path)
	set_process(true)
	
func finish_loading(node):
	add_child(node.instance())
	$game.connect('return_to_main', self, 'return_to_main')
	$game.hide()
	$loading/loading_text.set_text('ready!\r\nclick to continue')
	loaded_flag = true
	$options_menu.load_and_apply_options()

func return_to_main():
	$game.hide()
	$main_menu.show()
	$main_menu/audio.play()

func load_file(file):
	fade_out = file
	
func _on_click_to_continue_pressed():
	fade_out_loading = true
	
func _on_start_pressed():
	fade_out = -1

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
				
	if fade_out != null:
		if not $cover.visible:
			$cover.show()
		var a = $cover.color.a
		
		if a == 1:
			var file = fade_out
			fade_out = null
			$main_menu/audio.stop()
			$main_menu/audio.volume_db = -3
			
			$delay_timer.start()
			yield($delay_timer, 'timeout')
			
			$game.load_game(file)
			$main_menu.hide()
			$load_menu.hide()
			$cover.color = Color(1, 1, 1, 0)
			$cover.hide()
			$game.show()
			$game/main_audio.play()
			
		else:
			a = min(a + 2 * delta, 1)
			$main_menu/audio.volume_db = $main_menu/audio.volume_db - 40 * delta
			$cover.color = Color(1, 1, 1, a)
			
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