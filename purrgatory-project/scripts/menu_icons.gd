extends TextureRect

export var animation0: Texture = null
export var animation1: Texture = null
export var animation2: Texture = null
var anim_textures = []
var anim_frame = 0

func _ready():
	for texture in [animation0, animation1, animation2]:
		if texture:
			anim_textures.append(texture)
	if anim_textures.size() > 1:
		get_tree().get_root().get_node('main/game').connect('animation_tick', self, '_on_animation_tick')
	
func _on_animation_tick():
	anim_frame = (anim_frame + 1) % anim_textures.size()
	texture = anim_textures[anim_frame]

# this is all basically copied from char_obj_button.gd
# i probably should have made a base "wobbly texture" class and then extended that, but whatever
