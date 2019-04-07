tool

extends Navigation2D

export(Texture) var lightmap setget set_lightmap,get_lightmap
var lightmap_data
export(Texture) var scales setget set_scales,get_scales
export var bitmaps_scale = Vector2(1,1) setget set_bm_scale,get_bm_scale

#warning-ignore:unused_class_variable
export var player_speed_multiplier = 1.0  # Override player speed in current scene
#warning-ignore:unused_class_variable
export var player_doubleclick_speed_multiplier = 1.5  # Make the player move faster when doubleclicked
export var lightmap_modulate = Color(1, 1, 1, 1)
export(int, "None", "Scales", "Lightmap") var debug_mode = 1 setget debug_mode_updated

var texture
var img_area
var _texture_dirty = false

func set_bm_scale(p_scale):
	bitmaps_scale = p_scale
	_update_texture()

func get_bm_scale():
	return bitmaps_scale

func set_lightmap(p_lightmap):
	var need_init = (lightmap != p_lightmap) or (lightmap and not lightmap_data)

	lightmap = p_lightmap

	# It's bad enough a new copy is created when reading a pixel, we don't
	# also need to get the data for every read to make yet another copy
	if need_init:
		if lightmap_data:
			lightmap_data.unlock()
		lightmap_data = lightmap.get_data()
		lightmap_data.lock()

	_update_texture()

func get_lightmap():
	return lightmap

func set_scales(p_scales):
	scales = p_scales
	_update_texture()

func get_scales():
	return scales

func debug_mode_updated(p_mode):
	debug_mode = p_mode
	_update_texture()

func _update_texture():
	if _texture_dirty:
		return

	_texture_dirty = true
	call_deferred("_do_update_texture")

func _do_update_texture():
	_texture_dirty = false
	if !is_inside_tree():
		return
	if !Engine.is_editor_hint():
		return

	if debug_mode == 0:
		update()
		return

	texture = ImageTexture.new()
	if debug_mode == 1:
		if scales != null:
			#texture.create_from_image(scales)
			texture = scales
	else:
		if lightmap != null:
			#texture.create_from_image(lightmap)
			texture = lightmap

	update()



func make_local(pos):
	pos = pos - get_position()
	pos = pos * 1.0 / get_scale()
	if self is Navigation2D:
		pos = get_closest_point(pos)
	return pos

func make_global(pos):
	pos = pos * get_scale()
	pos = pos + get_position()
	return pos

func get_terrain_path(p_src, p_dest):
	# printt("get path ", p_src, p_dest)
	if !(self is Navigation2D):
		printt("returning a line")
		return [p_src, p_dest]
	p_src = make_local(p_src)
	p_dest = make_local(p_dest)

	var r_path = get_simple_path(p_src, p_dest, true)
	r_path = Array(r_path)
	for i in range(0, r_path.size()):
		r_path[i] = make_global(r_path[i])
	return r_path

func is_solid(pos):
	pos = pos - get_position()
	pos = pos * 1.0 / get_scale()

	var closest = get_closest_point(pos)
	return pos == closest

func _color_mul(a, b):
	var c = Color()
	c.r = a.r * b.r
	c.g = a.g * b.g
	c.b = a.b * b.b
	c.a = a.a * b.a
	return c

func get_light(pos):
	if not lightmap or lightmap.get_data().is_empty():
		return

	return _color_mul(get_pixel(pos, lightmap_data), lightmap_modulate)

func get_pixel(pos, p_image):
	p_image.lock()

	pos = make_local(pos)
	pos = pos * 1.0 / bitmaps_scale

	if pos.x + 1 >= p_image.get_width() || pos.y + 1 >= p_image.get_height() || pos.x < 0 || pos.y < 0:
		return Color()

	var ll = p_image.get_pixel(pos.x, pos.y)
	var ndif = Vector2()
	ndif.x = pos.x - floor(pos.x)
	ndif.y = pos.y - floor(pos.y)
	var ur

	img_area = Rect2(0, 0, p_image.get_width(), p_image.get_height())

	var lr = ll
	if ndif.x > 0 && img_area.has_point(Vector2(pos.x+1, pos.y)):
		lr = p_image.get_pixel(pos.x+1, pos.y)
		#if lr.a < 128:
		#	lr = ll
		ur = lr

	var ul = ll
	if ndif.y > 0 && img_area.has_point(Vector2(pos.x, pos.y+1)):
		ul = p_image.get_pixel(pos.x, pos.y+1)
		#if ul.a < 128:
		#	ul = ll
		ur = ul

	if ndif.x > 0 && ndif.y > 0 && img_area.has_point(Vector2(pos.x+1, pos.y+1)):
		var pix = p_image.get_pixel(pos.x+1, pos.y+1)
		#if pix.a > 128:
		ur = pix

	var bottom = ll.linear_interpolate(lr, ndif.x)
	var top
	if ur != null:
		top = ul.linear_interpolate(ur, ndif.x)
	else:
		top = ul

	var final = bottom.linear_interpolate(top, ndif.y)

	p_image.unlock()
	return final
