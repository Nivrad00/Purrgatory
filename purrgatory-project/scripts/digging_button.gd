extends PolygonButton

export var dialog_label = ''

func _ready():
	.set_highlight_on_hover(true)
	connect("pressed", self, "on_pressed")
	$hole.hide()
	$polygon.disabled = false
	$hole_button/polygon.disabled = true
	$hole_button.connect('start_dialog', get_parent(), 'start_dialog')
	
	for child in get_children():
		if child.name.substr(0, 6) == 'shovel':
			visible_polygons = [child]
	
func on_pressed():
	get_parent().start_dialog(dialog_label.strip_edges(), [])
	dug_hole()
	
func dug_hole():
	$hole.show()
	$polygon.disabled = true
	$hole_button/polygon.disabled = false
