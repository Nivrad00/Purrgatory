extends Button

export var value = ''
var default

func _ready():
	default = $Sprite.position.y

func _on_Button_button_up():
	$Sprite.position.y = default

func _on_Button_button_down():
	get_parent().get_parent().button_pressed(value)
	if get_node_or_null('beep'):
		$beep.play()
	$Sprite.position.y = default + 2
