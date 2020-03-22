extends KeyboardKey

var default_pos = null
var type = 'black'

func _ready():
	default_pos = $line.position
	# connect("key_up", self, "on_key_up")
	# connect("key_down", self, "on_key_down")

func on_key_down():
	$line.position = default_pos + Vector2(0, 10)

func on_key_up():
	$line.position = default_pos