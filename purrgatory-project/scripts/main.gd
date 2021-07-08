extends Node

# null when not fading out
# -1 when fading out to start a new game
# n when fading out to load save file n
var fade_out = null
var fade_out_loading = false
var game_path = 'res://scenes/game.tscn'
var loaded_flag = false

signal game_ready()

export var web_build = false
export var version = ''

func _ready():
	set_process(true)
	
	# change things for web build, if needed
	
	if web_build:
		$main_menu/buttons/exit.hide()
		$main_menu.rect_position.y = 17
		$credits/ScrollContainer/VBoxContainer/version.text = 'version ' + version + ' web'
	else:
		$main_menu/buttons/exit.show()
		$main_menu.rect_position.y = -14
		$credits/ScrollContainer/VBoxContainer/version.text = 'version ' + version + ' downloadable'
	
	# if it's the web build, wait so that it shows the loading screen
	# (the downloadable builds use the splash screen as the loading screen)
	if web_build:
		yield(get_tree().create_timer(0.01), 'timeout')
		yield(get_tree(), 'idle_frame')
	
	var node = load(game_path)
	add_child(node.instance())
	$game.connect('return_to_main', self, 'return_to_main')
	$game.hide()
	
	var rotating_cat = $rotating_cat
	remove_child(rotating_cat)
	$game/content/room/rotating_cat_container.add_child(rotating_cat)
	
	# wait so that it doesn't immediately pass "ready" if you clicked during "loading"
	yield(get_tree(), 'idle_frame')
	
	$loading/loading_text.set_text('ready!\r\nclick to continue')
	loaded_flag = true
	$options_menu.load_and_apply_options()
	
	emit_signal('game_ready')

func return_to_main():
	$game.hide()
	$main_menu.show()
	$main_menu/audio.play()
	AudioServer.set_bus_mute(0, false)
	AudioServer.set_bus_volume_db(0, 0)

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
		
	if fade_out != null:
		if not $cover.visible:
			$cover.show()
		var a = $cover.color.a
		
		if a == 1:
			var file = fade_out
			fade_out = null
			$main_menu/audio.stop()
			$main_menu/audio.volume_db = -6
			
			$delay_timer.start()
			yield($delay_timer, 'timeout')
			
			$game.load_game(file)
			$main_menu.hide()
			$load_menu.hide()
			$cover.color = Color(1, 1, 1, 0)
			$cover.hide()
			
			yield(get_tree(), 'idle_frame')
			$game.show()
			# we have the game speak the ui, if enabled, as soon as it's shown
			# $game/content/ui.speak_ui() # i guess it's not needed?
			if $game.main_audio:
				$game.main_audio.play()
			
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

# this is a version of the function from game.gd in case you delete 
# data while on the main menu
func deleted_data():
	if $game:
		$game.seen_blocks = []
