extends Control

signal start_dialog(label)
signal change_room(label)
signal start_action_timer(actions, callback)
signal change_audio(song)

var hidden_sprites = null
var dialog_ongoing = false

func _ready():
	var children = $state_handler.get_children()
	children.append($state_handler)
	for child in children:
		var signal_list = child.get_signal_list()
		for sig in signal_list:
			if sig['name'] == "start_dialog":
				child.connect("start_dialog", self, "start_dialog")
			if sig['name'] == "change_room":
				child.connect("change_room", self, "change_room")
			if sig['name'] == "set_hidden_sprite":
				child.connect("set_hidden_sprite", self, "set_hidden_sprite")
			if sig['name'] == "start_action_timer":
				child.connect("start_action_timer", self, "start_action_timer")
			if sig['name'] == "change_audio":
				child.connect("change_audio", self, "change_audio")
	
func set_hidden_sprite(sprites):
	if hidden_sprites != null:
		for sprite in hidden_sprites:
			sprite.show()
	hidden_sprites = sprites
	for sprite in sprites:
		sprite.hide()
	
func update_state(state):
	$state_handler.update_state(state)
	if hidden_sprites != null:
		for sprite in hidden_sprites:
			sprite.hide()

func init_state(state):
	$state_handler.init_state(state)

func play_default_music():
	$state_handler.play_default_music()
	
func start_dialog(label, sprites):
	if dialog_ongoing:
		return
	else:
		dialog_ongoing = true
		
	if sprites != null:
		for sprite in sprites:
			sprite.hide()
	hidden_sprites = sprites
	emit_signal('start_dialog', label)

func end_dialog():
	dialog_ongoing = false
	if hidden_sprites != null:
		for sprite in hidden_sprites:
			sprite.show()
	hidden_sprites = null

func change_room(label):
	emit_signal('change_room', label)

func start_action_timer(actions, callback):
	emit_signal('start_action_timer', actions, callback)
	
func change_audio(song):
	emit_signal('change_audio', song)
