extends Area2D

class_name PolygonButton

var highlight_on_hover = false
var input
var visible_polygons = []
var hovering = 0 # number of polygons that are being hovered over
var holding_click = false

signal pressed()
signal mouse_down()

func _ready():
	# print("ready")
	
	# get input object
	input = Input
	
	# make visible polygon, if there is none
	var children = get_children()
	var visible_exists = false
	
	for child in children:
		if child is Polygon2D:
			visible_polygons.append(child)
			visible_exists = true
	
	if not visible_exists:
		make_visible_polygons()
		
	# hook up hover methods
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	connect("input_event", self, "input_event")

func make_visible_polygons():
	for collision_polygon in get_children():
		if collision_polygon is CollisionPolygon2D:	
			var new_polygon = Polygon2D.new()
			new_polygon.set_polygon(collision_polygon.get_polygon())
			new_polygon.position = collision_polygon.position
			new_polygon.set_modulate(Color(0, 0, 0, 0.1))
			new_polygon.hide()
			visible_polygons.append(new_polygon)
			add_child(new_polygon)
	
func mouse_entered():
	hovering += 1
	# print("mouse entered")
	
func mouse_exited():
	hovering -= 1
	# print("mouse exited")
	
func mouse_clicked_on_button():
	holding_click = true
	emit_signal("mouse_down")
	# print("mouse clicked")
	
func mouse_released():
	if holding_click:
		holding_click = false
		# print("mouse released")
		if hovering > 0:
			emit_signal("pressed")
			# print("press!")
	
func input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		mouse_clicked_on_button()
	
func _process(delta):
	if highlight_on_hover:
		if holding_click or hovering > 0:
			for child in visible_polygons:
				child.show()
		else:
			for child in visible_polygons:
				child.hide()
		
	if input.is_action_just_released('ui_click'):
		mouse_released()
		
func set_highlight_on_hover(value):
	highlight_on_hover = value