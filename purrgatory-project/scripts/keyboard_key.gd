extends Area2D

class_name KeyboardKey

var visible_polygons = []
var hovering = 0 # number of polygons that are being hovered over
var holding_click = false

signal key_down(key)
signal key_up(key)

func _ready():
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	
func mouse_entered():
	hovering += 1
	if hovering == 1 and Input.is_mouse_button_pressed(BUTTON_LEFT):
		mouse_pressed()
	
func mouse_exited():
	hovering -= 1
	if holding_click and hovering == 0:
		mouse_released()
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			mouse_pressed()
		elif holding_click:
			mouse_released()
	
func mouse_pressed():
	holding_click = true
	emit_signal("key_down", self)
	
func mouse_released():
	holding_click = false
	emit_signal("key_up", self)
	
func play_note():
	$sound.play()