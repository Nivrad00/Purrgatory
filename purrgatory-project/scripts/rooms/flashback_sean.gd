extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 2: 1 }
	ending_label = "end_flashback"
	
func wake_up():
	.wake_up()
	
	# all languages
	
	set_format_dict('partner_name', input_text.get(2, ""))
	
	# english
	
	var replacements = [
		'partner',
		'best friend',
		'partner'
	]
	set_format_dict('partner', replacements[choice_log[1]])
	set_format_dict('partner_about', choice_text[3])
	
	# spanish
	
	var partner_es_replacements = [
		'pareja',
		'mejor amigx',
		'pareja'
	]
	var partner_about_es_replacements = [
		'salir a pasear después de una tormenta',
		'hacer reír a los demás',
		'terminarse un buen libro',
		'tomarse algo después de un largo día de trabajo',
		'ver a la gente ir y venir en la estación de tren',
		'coger el coche e irse de viaje a sitios lejanos',
		'pasarse toda la mañana del domingo durmiendo'
	]
	set_format_dict('partner_es', partner_es_replacements[choice_log[1]])
	set_format_dict('partner_about_es', partner_about_es_replacements[choice_log[3]])
	
	# chinese (placeholder)
	
	var partner_ch_replacements = [
		'情人',
		'朋友',
		'爱人'
	]
	var partner_about_ch_replacements = [
		'在暴风雨后出门散步',
		'让其他人发笑',
		'读完一本好书',
		'一天工作之后畅饮一杯',
		'在火车站去看人来人往',
		'超长的自驾旅行',
		'在温暖的周日早晨睡到自然醒'
	]
	set_format_dict('partner_ch', partner_ch_replacements[choice_log[1]])
	set_format_dict('partner_about_ch', partner_about_ch_replacements[choice_log[3]])
	
	# italian
	
	var partner_it_replacements = [
		"la persona che frequentavo",
		"la persona a cui volevo più bene",
		"la persona che frequentavo"
	]
	var partner_about_it_replacements = [
		"fare una passeggiata dopo un temporale",
		"far ridere le altre persone",
		"finire di leggere un bel libro",
		"bersi qualcosa dopo una giornata di lavoro",
		"osservare le persone in stazione",
		"fare dei road trip molto lunghi",
		"stare a letto la domenica mattina"
	]
	set_format_dict('partner_it', partner_it_replacements[choice_log[1]])
	set_format_dict('partner_about_it', partner_about_it_replacements[choice_log[3]])
	
	# polish
	
	var partner_pl_replacements = [
		"moja druga połówka",
		"mój przyjaciel",
		"moja druga połówka"
	]
	var partner_about_pl_replacements = [
		"chodzić na spacery po burzy",
		"sprawiać, by inni się śmiali",
		"czytać dobre książki",
		"zrelaksować się przy drinku po dniu pracy",
		"obserwować ludzi na dworcu kolejowym",
		"chodzić na długie wycieczki",
		"długo spać w niedzielne poranki"
	]
	set_format_dict('partner_pl', partner_pl_replacements[choice_log[1]])
	set_format_dict('partner_about_pl', partner_about_pl_replacements[choice_log[3]])
	
	# portuguese
	
	var partner_pt_replacements = [
		"parça",
		"amigo",
		"parça"
	]
	var partner_about_pt_replacements = [
		"caminhar depois de uma tempestade",
		"fazer as pessoas rirem",
		"terminar um bom livro",
		"relaxar com uma bebida depois de um dia de trabalho",
		"observar pessoas na estação de trem",
		"cair em longas viagens na estrada",
		"dormir em uma manhã quentinha de domingo"
	]
	set_format_dict('partner_pt', partner_pt_replacements[choice_log[1]])
	set_format_dict('partner_about_pt', partner_about_pt_replacements[choice_log[3]])
	
	# spanish latam
	
	var partner_es2_replacements = [
		"pareja",
		"mejor amigx",
		"pareja"
	]
	var partner_about_es2_replacements = [
		"salir a caminar después de una tormenta",
		"hacer reír a las demás personas",
		"terminarse un buen libro",
		"relajarse y beber algo después de un duro día de trabajo",
		"mirar qué hacían las personas en la estación de tren",
		"hacer largos viajes en su auto",
		"quedarse durmiendo toda la mañana en un cálido domingo"
	]
	set_format_dict('partner_es2', partner_es2_replacements[choice_log[1]])
	set_format_dict('partner_about_es2', partner_about_es2_replacements[choice_log[3]])
	
	# done 
	
	emit_signal('change_room', 'hallway1')
