extends TextureButton

export var dialog_label = ''
# if blank, the character does not have special dialog during the blackout
export var blackout_label = ''
export var sprite_path = []

export var animation0: Texture = null
export var animation1: Texture = null
export var animation2: Texture = null
var anim_frame = 0
var anim_textures = []

signal start_dialog(label, blackout_label, sprite)
signal stop_all_hovering()

# this script/scene should now only be used for texture buttons (sprites), and not polygon buttons

func _ready():
	for texture in [animation0, animation1, animation2]:
		if texture:
			anim_textures.append(texture)
	if anim_textures.size() > 1:
		get_tree().get_root().get_node('main/game').connect('animation_tick', self, '_on_animation_tick')
	
func _gui_input(event):
	if event is InputEventMouseMotion:
		emit_signal("stop_all_hovering")
	
func _on_char_obj_button_pressed():
	if sprite_path.size() == 0:
		if blackout_label == '':
			emit_signal('start_dialog', dialog_label, [self], dialog_label)
		else:
			emit_signal('start_dialog', dialog_label, [self], blackout_label)
	else:
		var sprites = []
		for path in sprite_path:
			if path == null: # a hack to say "don't send any sprites"
				continue
			sprites.append(get_node(path))
		if blackout_label == '':
			emit_signal('start_dialog', dialog_label, sprites, dialog_label)
		else:
			emit_signal('start_dialog', dialog_label, sprites, blackout_label)
	# this signal will be connected to the root node of the room (room_instance.gd)

func _on_animation_tick():
	anim_frame = (anim_frame + 1) % anim_textures.size()
	texture_normal = anim_textures[anim_frame]
		

