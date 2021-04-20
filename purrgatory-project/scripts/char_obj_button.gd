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

var mouse_on = false

signal start_dialog(label, blackout_label, sprite)
signal stop_all_hovering()
signal start_all_hovering()

# this script/scene should now only be used for texture buttons (sprites), and not polygon buttons
# update: this script is now used for any in-game texture that needs a wobbly animation, for consistency,
#   even the ones that aren't interactible
# i probably should have made a new script for non-interactible wobbly sprites but whatevs

func _ready():
	for texture in [animation0, animation1, animation2]:
		if texture:
			anim_textures.append(texture)
	if anim_textures.size() > 1:
		get_tree().get_root().get_node('main/game').connect('animation_tick', self, '_on_animation_tick')
		
	connect('mouse_entered', self, '_on_mouse_entered')
	connect('mouse_exited', self, '_on_mouse_exited')
	connect('visibility_changed', self, '_on_visibility_changed')

func _on_mouse_entered():
	emit_signal("stop_all_hovering")
	mouse_on = true
	
func _on_mouse_exited():
	emit_signal("start_all_hovering")
	mouse_on = false

func _on_visibility_changed():
	if not visible and mouse_on:
		emit_signal("start_all_hovering")
		mouse_on = false
		
	
	
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
		

