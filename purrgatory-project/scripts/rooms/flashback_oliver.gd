extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 3: 2 }
	ending_label = 'oliver_end_pride_flashback'
		
func wake_up():
	.wake_up()
	
	# english
	
	var replacements = [ 
		'always nice to strangers',
		'always honest',
		'pretty smart and well-spoken',
		'good-looking',
		'always there for my friends',
		'a decent musician',
		'always optimistic'
	]
	
	set_format_dict('pride', replacements[choice_log[1]])
	set_format_dict('proudest_moment', choice_text[2])
	
	# spanish
	
	var pride_es_replacements = [ 
		'amable con todo el mundo',
		'honrad{o/a/e} y just{o/a/e}',
		'astut{o/a/e} y elocuente',
		'muy guap{o/a/e}',
		'leal a los míos',
		'un{/a/e} gran músico',
		'muy optimista'
	]
	var proudest_moment_es_replacements = [ 
		'ganar un concurso de poesía en 6º de primaria',
		'tocar la guitarra en lo alto de un escenario por primera vez',
		'terminar mi primera media maratón',
		'coger en brazos por primera vez a mi hijx',
		'romper el récord mundial de un videojuego',
		'sacarme el título universitario',
		'cortarme el pelo'
	]
	set_format_dict('pride_es', pride_es_replacements[choice_log[1]])
	set_format_dict('proudest_moment_es', proudest_moment_es_replacements[choice_log[2]])
	
	# chinese

	var pride_ch_replacements = [ 
		'一直对陌生人很善良',
		'一直真诚且坚强',
		'一直很聪慧而且善于言辞',
		'一直很漂亮',
		'一直为朋友两肋插刀',
		'是个有才的音乐家',
		'一直保持无尽的乐观'
	]
	var proudest_moment_ch_replacements = [ 
		'六年级时赢得了单词拼写比赛',
		'第一次上台表演吉他',
		'跑完了第一次半程马拉松',
		'有了我的第一个孩子',
		'在一个游戏上取得世界纪录',
		'从大学毕业',
		'把头发剪掉了'
	]
	set_format_dict('pride_ch', pride_ch_replacements[choice_log[1]])
	set_format_dict('proudest_moment_ch', proudest_moment_ch_replacements[choice_log[2]])
	
	# italian
	
	var pride_it_replacements = [ 
		"la gentilezza con gli sconosciuti",
		"l'onestà e la resilienza",
		"la mia intelligenza ed eloquenza",
		"la mia bellezza impareggiabile",
		"l'esserci sempre per gli amici",
		"il mio talento musicale",
		"l'essere sempre ottimista"
	]
	var proudest_moment_it_replacements = [ 
		"ho vinto il concorso di poesia alle elementari",
		"ho suonato la chitarra per la prima volta su un palco",
		"ho finito la mia prima mezza maratona",
		"è nato il mio primo figlio",
		"ho fatto un record mondiale a un videogioco",
		"ho finito l'università",
		"ho tagliato i capelli"
	]
	set_format_dict('pride_it', pride_it_replacements[choice_log[1]])
	set_format_dict('proudest_moment_it', proudest_moment_it_replacements[choice_log[2]])
	
	# polish
	
	var pride_pl_replacements = [ 
		"mił{y/a/e/x} dla obcych",
		"szczer{y/a/e/x} i wytrwał{y/a/e/x}",
		"mądr{y/a/e/x} i elokwentn{y/a/e/x}",
		"przepiękn{y/a/e/x}",
		"zawsze obecn{y/a/e/x} dla przyjaciół",
		"utalentowanym muzykiem",
		"nieskończenie optymistyczn{y/a/e/x}"
	]
	var proudest_moment_pl_replacements = [ 
		"wygraniu konkursu literowania w szóstej klasie",
		"pierwszym występie na scenie",
		"ukończeniu pierwszego półmaraton",
		"narodzinach pierwszego dziecka",
		"ustanowieniu rekordu świata w grze komputerowej",
		"ukończeniu studiów",
		"ścięciu włosów"
	]
	set_format_dict('pride_pl', pride_pl_replacements[choice_log[1]])
	set_format_dict('proudest_moment_pl', proudest_moment_pl_replacements[choice_log[2]])
	
	# portuguese
	
	var pride_pt_replacements = [ 
		"gentil com estranhos",
		"honest{o/a/e} e resiliente",
		"inteligente e bo{m/a/e} com as palavras",
		"indescritivelmente bel{o/a/e}",
		"sempre presente para meus amigos",
		"um{/a/e} musicista talentos{a/o/e}",
		"um poço sem fundo de otimismo"
	]
	var proudest_moment_pt_replacements = [ 
		"venci o campeonato de soletrar do sexto ano",
		"toquei guitarra no palco",
		"terminei minha primeira meia maratona",
		"tive minha primeira criança",
		"consegui um recorde mundial em um video game",
		"graduei na faculdade",
		"cortei meu cabelo"
	]
	set_format_dict('pride_pt', pride_pt_replacements[choice_log[1]])
	set_format_dict('proudest_moment_pt', proudest_moment_pt_replacements[choice_log[2]])
	
	# spanish latam
	
	var pride_es2_replacements = [ 
		"amable con los desconocidos",
		"honest{o/a/e} y resiliente",
		"elocuente y ocurrente",
		"hermosamente deslumbrante",
		"leal con tus amigos",
		"un{/a/e} talentos{o/a/e} músi{co/ca/que}",
		"infinitamente optimista"
	]
	var proudest_moment_es2_replacements = [ 
		"gané un concurso literario en 6to grado de primaria",
		"toqué por primera vez la guitarra en un escenario",
		"terminé mi primer medio maratón",
		"tuve a mi primer bebé",
		"conseguí un record mundial en un videojuego",
		"me gradué de la universidad",
		"me corté el pelo"
	]
	set_format_dict('pride_es2', pride_es2_replacements[choice_log[1]])
	set_format_dict('proudest_moment_es2', proudest_moment_es2_replacements[choice_log[2]])
	
func update_state(state):
	.update_state(state)
	if state.get('flashback_goto_commons'):
		emit_signal('change_room', 'commons1')
