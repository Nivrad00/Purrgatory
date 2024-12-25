extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 3: 2 }
	ending_label = null

func wake_up():
	.wake_up()
	
	# english
	
	var replacements = [
		'see the mountains',
		'hear the streets',
		'smell the ocean',
		'see the dusty roads',
		'feel the muggy air', 
		'see the perfect lawns',
		'see the leaky roof'
	]
	set_format_dict('hometown', replacements[choice_log[1]])
	
	var replacements2 = [
		'the corner store',
		'the creek',
		'the bookstore',
		'my great-aunt\'s house',
		'the arcade', 
		'the back of my family\'s store',
		'the soccer field'
	]
	set_format_dict('favorite_place', replacements2[choice_log[2]])
	
	# spanish
	
	var hometown_es_replacements = [
		'de las montañas que adornaban el paisaje',
		'del gentío y la cháchara en las calles',
		'de las olas rompiendo en la costa',
		'de las viejas carreteras que se perdían en el horizonte',
		'del ambiente cálido y húmedo',
		'del césped tan bien cuidado',
		'del techo que siempre estaba a punto de colapsar'
	]
	set_format_dict('hometown_es', hometown_es_replacements[choice_log[1]])
	
	var favorite_place_es_replacements = [
		'la tienda que hacía esquina y olía tan bien',
		'el descansillo rocoso a la orilla del arroyo',
		'la librería del final de mi calle',
		'el casoplón de mi tía abuela',
		'la sala de recreativos del centro comercial',
		'la trastienda del restaurante de mi familia',
		'el campo de fútbol de detrás de la escuela, que estaba tan mal cuidado'
	]
	set_format_dict('favorite_place_es', favorite_place_es_replacements[choice_log[2]])
	
	# chinese
	
	var hometown_ch_replacements = [
		'远处群山连绵',
		'街道熙熙攘攘',
		'海浪拍打岸边',
		'尘路延至天际',
		'空气闷热潮湿',
		'田园精心照料',
		'屋顶摇摇欲坠'
	]
	set_format_dict('hometown_ch', hometown_ch_replacements[choice_log[1]])
	
	var favorite_place_ch_replacements = [
		'转角那有肥皂味的小卖部',
		'溪流旁的卵石浅滩',
		'老街另一头的书店',
		'婶婶奢华的家',
		'商场里五光十色的街机厅',
		'家里小店的后屋',
		'学校后杂草疯长的田径场'
	]
	set_format_dict('favorite_place_ch', favorite_place_ch_replacements[choice_log[2]])
	
	# italian
	
	var hometown_it_replacements = [
		"le montagne in lontananza",
		"le strade erano sempre piene di gente",
		"le onde si infrangevano sulla riva",
		"le strade sterrate continuavano senza fine",
		"l'aria era umida e afosa",
		"i prati erano ben curati",
		"il tetto rischiava di crollare da un momento all'altro"
	]
	set_format_dict('hometown_it', hometown_it_replacements[choice_log[1]])
	
	var favorite_place_it_replacements = [
		"il negozio all'angolo che profumava di sapone",
		"l'ansa rocciosa del fiume",
		"la libreria in fondo alla strada",
		"la casa sfarzosa della mia prozia",
		"la sala giochi al centro commerciale",
		"il retro del negozio di famiglia",
		"il campetto da calcio poco curato dietro la scuola"
	]
	set_format_dict('favorite_place_it', favorite_place_it_replacements[choice_log[2]])
	
	# polish
	
	var hometown_pl_replacements = [
		"góry były zawsze na horyzoncie",
		"ulice były wypełnione rozmowami",
		"fale rozbijały się o brzeg",
		"drogi polne rozciągały się aż po horyzont",
		"powietrze było parne i gorące",
		"trawniki były równo przycięte",
		"dach zawsze groził zawaleniem"
	]
	set_format_dict('hometown_pl', hometown_pl_replacements[choice_log[1]])
	
	var favorite_place_pl_replacements = [
		"sklep na rogu, który pachniał mydłem",
		"skalista zatoka",
		"sklep z książkami na końcu ulicy",
		"bogaty dom stryjecznej ciotki",
		"błyszczący salon gier w centrum handlowym",
		"zaplecze w rodzinnym sklepie",
		"zarośnięte boisko za szkołą"
	]
	set_format_dict('favorite_place_pl', favorite_place_pl_replacements[choice_log[2]])
	
	# portuguese
	
	var hometown_pt_replacements = [
		"ver as montanhas",
		"ouvir as ruas",
		"sentir o cheiro do oceano",
		"ver as estradas empoeiradas",
		"sentir o ar abafado e quente",
		"ver os gramados polidos à perfeição",
		"ver o teto desgastado"
	]
	set_format_dict('hometown_pt', hometown_pt_replacements[choice_log[1]])
	
	var favorite_place_pt_replacements = [
		"a loja da esquina",
		"o bosque",
		"a livraria",
		"a casa opulenta da minha tia avó",
		"o fliperama",
		"os fundos da loja da minha família",
		"o campo de futebol"
	]
	set_format_dict('favorite_place_pt', favorite_place_pt_replacements[choice_log[2]])
	
	# spanish latam
	
	var hometown_es2_replacements = [
		"de las montañas que siempre se veían en el fondo del paisaje",
		"de las calles repletas de conversaciones y personas",
		"de las olas del mar que chocaban contra la costa",
		"de las polvorientas carreteras que se perdían en el horizonte",
		"del aire húmedo y cálido",
		"de que el pasto estaba cuidadosamente cortado",
		"del techo siempre parecía estar al borde de colapsar"
	]
	set_format_dict('hometown_es2', hometown_es2_replacements[choice_log[1]])
	
	var favorite_place_es2_replacements = [
		"la tienda de la esquina que olía como a jabón ",
		"el camino rocoso cerca del arroyo",
		"la biblioteca de la cuadra",
		"la opulenta casa de tu tía abuela",
		"la llamativa sala de arcade del centro comercial",
		"la parte de atrás del restaurante familiar",
		"la cancha de fútbol cubierta de vegetación detrás de la escuela"
	]
	set_format_dict('favorite_place_es2', favorite_place_es2_replacements[choice_log[2]])
	
	# done
	
	emit_signal('change_room', 'flashback_kyungsoon')
