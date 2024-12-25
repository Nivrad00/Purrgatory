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

	var food_it_replacements = [
		"i mirtilli",
		"i burrito",
		"la pizza con l'ananas",
		"il pollo al forno",
		"i biscotti",
		"il ramen",
		"il cioccolato fondente",
		"le ostriche",
		"le alette di pollo",
		"il pollo al curry",
		"la bistecca",
		"i ravioli cinesi",
		"le patatine fritte",
		"il burro d'arachidi"
	]
	set_format_dict('food_it', food_it_replacements[choice_log[1]])
	
	var food_pl_replacements = [
		"jagody",
		"burrito",
		"pizza z ananasem",
		"adobo",
		"płatki kukurydziane",
		"zupa pho",
		"ciemna czekolada",
		"świeże ostrygi",
		"skrzydełka na ostro",
		"kurczak tikka masala",
		"antrykot",
		"pierogi",
		"frytki",
		"masło orzechowe"
	]
	set_format_dict('food_pl', food_pl_replacements[choice_log[1]])
	
	var food_pt_replacements = [
		"mirtilos",
		"burritos",
		"pizza de abacaxi",
		"adobo",
		"sucrilhos",
		"vatapá",
		"chocolate meio amargo",
		"ostras frescas",
		"assinhas de frango",
		"galinhada",
		"filé de costela",
		"pão de queijo",
		"batatas fritas",
		"paçoca"
	]
	set_format_dict('food_pt', food_pt_replacements[choice_log[1]])
	
	var food_es2_replacements = [
		"eran los arándanos",
		"eran los burritos",
		"era la pizza con piña",
		"era el adobo arequipeño",
		"era el cereal con malvaviscos",
		"era la sopa maruchan",
		"era el chocolate negro",
		"eran las rabas",
		"era el pollo frito del kfc",
		"eran los porotos con riendas",
		"era el filete de res",
		"eran las empanadas de carne",
		"eran las papas fritas",
		"era el helado de maracuyá"
	]
	set_format_dict('food_es2', food_es2_replacements[choice_log[1]])
	
