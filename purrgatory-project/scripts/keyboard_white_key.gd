extends KeyboardKey

var default_pos = null
var type = 'white'

func _ready():
	default_pos = $Sprite.position
	# connect("key_up", self, "on_key_up")
	# connect("key_down", self, "on_key_down")

func on_key_down():
	$Sprite.position = default_pos + Vector2(0, 10)

func on_key_up():
	$Sprite.position = default_pos
	
