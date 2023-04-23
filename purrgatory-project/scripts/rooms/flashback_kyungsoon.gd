extends "flashback_template.gd"

func _ready():
	._ready()
	ending_label = "ks_post_flashback"
	
func wake_up():
	.wake_up()
	
	set_format_dict('food', choice_text[1])
	
	var food_es_replacements = [
		'flipaban los arándanos',
		'flipaban los burritos',
		'flipaba la pizza con piña',
		'flipaba el adobo',
		'flipaban los cereales de malvavisco',
		'flipaba el pho',
		'flipaba el chocolate negro',
		'flipaban las ostras frescas',
		'flipaban las alitas de pollo',
		'flipaba el pollo tikka masala',
		'flipaba el filete de costilla',
		'flipaban las empanadillas',
		'flipaban las patatas fritas',
		'flipaba la crema de cacahuete'
	]
	set_format_dict('food_es', food_es_replacements[choice_log[1]])
	
	# chinese (placeholder)
	set_format_dict('food_ch', choice_text[1])
