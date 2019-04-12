extends Control

signal start_dialog(label)
signal change_room(label)

var hidden_sprite = null

func _ready():
	for child in $state_handler.get_children():
		var signal_list = child.get_signal_list()
		for sig in signal_list:
			if sig['name'] == "start_dialog":
				child.connect("start_dialog", self, "start_dialog")
			if sig['name'] == "change_room":
				child.connect("change_room", self, "change_room")
			
func update_state(state):
	$state_handler.update_state(state)
	if hidden_sprite:
		hidden_sprite.hide()

func init_state(state):
	$state_handler.init_state(state)
	
func start_dialog(label, sprite):
	sprite.hide()
	hidden_sprite = sprite
	emit_signal('start_dialog', label)

func end_dialog():
	if hidden_sprite:
		hidden_sprite.show()
	hidden_sprite = null

func change_room(label):
	emit_signal('change_room', label)
