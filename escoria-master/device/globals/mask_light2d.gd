tool

export(Vector2) var front_pos
var pos2DZ

func init_mask():
	_update_terrain()
	update()
	
func get_front_position():
	if (has_node("front_pos")):
		front_pos = get_node("front_pos").get_global_position()
	return front_pos


func _update_terrain():
	var pos = get_front_position()
	set_z_index(pos.y)
	set_z_range_min( 1 ) 
	set_z_range_max( pos.y )

func debug_print_z():
	printt("MASKS node Z : ", get_z_index())
	printt("node", "name", "Z", "Z_range_min", "Z_range_max")
	printt("node", get_name(), get_z_index(), get_z_range_min(), get_z_range_max())
	print("\n")

func _ready():
	init_mask()
	#debug_print_z()
	pass


