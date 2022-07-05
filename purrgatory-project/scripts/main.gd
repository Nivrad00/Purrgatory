extends Node

# null when not fading out
# -2 when fading out to start a new game (-1 is taken by autosave, which is slot -1)
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
	# (options menu also changes based on this variable)
	
	if web_build:
		$main_menu/buttons/exit.hide()
		$main_menu.rect_position.y = 17
		$main_menu/language.rect_position.y = 616
		$credits/ScrollContainer/VBoxContainer/version.text = 'version ' + version + ' web'
		$credits/ScrollContainer/VBoxContainer/web_disclaimer1.show()
		$credits/ScrollContainer/VBoxContainer/web_disclaimer2.show()
	else:
		$main_menu/buttons/exit.show()
		$main_menu.rect_position.y = -14
		$main_menu/language.rect_position.y = 647
		$credits/ScrollContainer/VBoxContainer/version.text = 'version ' + version + ' downloadable'
		$credits/ScrollContainer/VBoxContainer/web_disclaimer1.hide()
		$credits/ScrollContainer/VBoxContainer/web_disclaimer2.hide()
	
	# if it's the web build, wait so that it shows the loading screen
	# (the downloadable builds use the splash screen as the loading screen, so no need)
	if web_build or true: # nvm just do it always, who knows how other OS's display it
		yield(get_tree().create_timer(0.01), 'timeout')
		yield(get_tree(), 'idle_frame')
	
	var node = load(game_path)
	add_child_below_node($cover, node.instance())
	$game.connect('return_to_main', self, 'return_to_main')
	$game.hide()
	
	var rotating_cat = $rotating_cat
	remove_child(rotating_cat)
	$game/content/room/rotating_cat_container.add_child(rotating_cat)
	
	# wait so that it doesn't immediately pass "ready" if you clicked during "loading"
	yield(get_tree(), 'idle_frame')
	
	$loading/loading_text.hide()
	$loading/ready_text.show()
	loaded_flag = true
	
	# load language options - this is copied directly from options_menu.gd
	for lang in Language.languages:
		$main_menu/language/language/dropdown.add_item(lang)
	# also connect it to the global signal
	Language.connect("language_changed", self, "_on_language_changed")
	# once that's connected, we can load and apply the options from file
	$options_menu.load_and_apply_options()
	
	# done 
	
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
	fade_out = -2

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

func _on_language_selected(ID):
	# when a language is selected on the main menu, apply the change the same as you would if it was selected in the options menu
	$options_menu._on_language_selected(ID) 
	# however, IMMEDIATELY save all options, for consistency
	$options_menu.save_options() 

func _on_language_changed(lang):
	# whenever the language is changed (presumably from an options menu, or when the game is loaded),
	#   update the dropdown option to reflect it
	# this connects to the global Language's signal "language_changed"
	$main_menu/language/language/dropdown.selected = lang
