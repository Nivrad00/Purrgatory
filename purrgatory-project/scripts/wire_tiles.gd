extends TextureRect

export var tile = 'blank'
var path = [self] 
var origin = null 
var cursor_shape = Input.CURSOR_ARROW

var images = {
	'blank': null,
	'node': null,
	'node_up': null,
	'node_right': null,
	'node_down': null,
	'node_left': null,
	'end_up': null,
	'end_right': null,
	'end_down': null,
	'end_left': null,
	'wire_up': null,
	'wire_right': null,
	'wire_down_right': null,
	'wire_down_left': null,
	'wire_up_left': null,
	'wire_up_right': null
}

var adjacent = {
	'up': null,
	'right': null,
	'down': null,
	'left': null
}

func _ready():
	mouse_default_cursor_shape = cursor_shape
	connect('mouse_entered', self, 'mouse_entered')
	connect('mouse_exited', self, 'mouse_exited')
	for image in images:
		images[image] = load('res://assets/sprites/wires/' + image + '.png')
	set_tile(tile)
	
func set_tile(label):
	tile = label
	texture = images[label]
	
	if label in get_parent().clickable:
		cursor_shape = Input.CURSOR_MOVE
	else:
		cursor_shape = Input.CURSOR_ARROW

func mouse_entered():
	get_parent().mouse_entered(self)

func mouse_exited():
	get_parent().mouse_exited(self)