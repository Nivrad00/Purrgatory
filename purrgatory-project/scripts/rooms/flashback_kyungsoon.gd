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
	
	var food_ch_replacements = [
		'蓝莓',
		'卷饼',
		'菠萝披萨',
		'炒饭',
		'棉花糖麦片',
		'河粉',
		'黑巧克力',
		'生蚝',
		'辣翅',
		'咖喱鸡',
		'肋眼牛排',
		'饺子',
		'薯条',
		'花生酱'
	]

	set_format_dict('food_ch', food_ch_replacements[choice_log[1]])
