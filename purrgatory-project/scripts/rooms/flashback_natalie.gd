extends "flashback_template.gd"

func _ready():
	._ready()

func init_state(state):
	.init_state(state)
	state['natalie_quest_complete'] = true
	
func wake_up():
	.wake_up()
		
	set_format_dict('dream', choice_text[1])
	set_format_dict('regret', choice_text[3])
	
	# spanish
	
	var dream_es_replacements = [
		'formar una familia',
		'aprender a programar',
		'publicar una novela juvenil',
		'mejorar mi técnica con los dardos',
		'vivir en una casita en el bosque',
		'retomar los estudios',
		'mudarme a otro país'
	]
	set_format_dict('dream_es', dream_es_replacements[choice_log[1]])
	
	var regret_es_replacements = [
		'haberles encontrado un nuevo hogar a mis perros',
		'haberle hecho una visita a mi familia en el pueblo',
		'haberme despedido de mis amigos',
		'haber apagado el horno',
		'haber eliminado ciertas cosas de mi ordenador',
		'haber donado mi colección de peluches',
		'haberme fundido todos los ahorros en pizza'
	]
	set_format_dict('regret_es', regret_es_replacements[choice_log[3]])
	
	# chinese
	
	var dream_ch_replacements = [
		'组建一个家庭',
		'学习如何编程',
		'出版一部青年小说',
		'练习飞镖技巧',
		'搬进林中的小屋',
		'在学业上继续深造',
		'前往另一个国家'
	]
	set_format_dict('dream_ch', dream_ch_replacements[choice_log[1]])
	
	var regret_ch_replacements = [
		'为我的狗找个新家',
		'拜访我的家乡',
		'向我的朋友们告别',
		'关掉烤箱',
		'删掉电脑上一些私人的东西',
		'把我的毛绒玩具收藏捐掉',
		'把存下的钱都花在披萨上'
	]
	set_format_dict('regret_ch', regret_ch_replacements[choice_log[3]])
		
	# italian
	
	var dream_it_replacements = [
		"fare una famiglia",
		"imparare a programmare",
		"pubblicare un libro",
		"migliorare a freccette",
		"vivere in un cottage nella foresta",
		"tornare a scuola",
		"vivere in un altro paese"
	]
	set_format_dict('dream_it', dream_it_replacements[choice_log[1]])
	
	var regret_it_replacements = [
		"trovare una nuova casa per i miei cani",
		"visitare la mia città natale",
		"dire addio ai miei amici",
		"spegnere il forno",
		"eliminare alcune cose private dal computer",
		"donare la mia collezione di peluche",
		"spendere tutti i miei soldi in pizza"
	]
	set_format_dict('regret_it', regret_it_replacements[choice_log[3]])
	
	# polish
	
	var dream_pl_replacements = [
		"założyć rodzinę",
		"nauczyć się programować",
		"wydać powieść dla młodzieży",
		"dobrze grać w rzutki",
		"mieszkać w chatce w lesie",
		"wrócić do szkoły",
		"przeprowadzić się do innego kraju"
	]
	set_format_dict('dream_pl', dream_pl_replacements[choice_log[1]])
	
	var regret_pl_replacements = [
		"znaleźć nowy dom dla swoich psów",
		"odwiedzić swoje miasto rodzinne",
		"pożegnać się z przyjaciółmi",
		"wyłączyć piekarnik",
		"usunąć trochę prywatnych rzeczy z komputera",
		"podarować komuś swoją kolekcję pluszaków",
		"wydać wszystkie swoje oszczędności na pizzę"
	]
	set_format_dict('regret_pl', regret_pl_replacements[choice_log[3]])
	
	# portuguese
	
	var dream_pt_replacements = [
		"começar uma família",
		"aprender a programar",
		"publicar um livro para jovens adultos",
		"aprender a jogar dardos",
		"viver em um sitio no interior",
		"voltar para a escola",
		"se mudar para outro país"
	]
	set_format_dict('dream_pt', dream_pt_replacements[choice_log[1]])
	
	var regret_pt_replacements = [
		"achar novos lares para os cachorros",
		"visitar sua cidade natal",
		"dizer adeus a seus amigos",
		"desligar o forno",
		"deletar os arquivos privados de seu computador",
		"doar sua coleção de bichos de pelúcia",
		"gastar o resto de suas economias com pizza"
	]
	set_format_dict('regret_pt', regret_pt_replacements[choice_log[3]])
	
	# spanish latam
	
	var dream_es2_replacements = [
		"formar una familia",
		"aprender a programar",
		"publicar una novela para jóvenes adultos",
		"ser buen{o/a/e} en los dardos",
		"vivir en una cabaña en el bosque",
		"volver a la escuela",
		"mudarme a otro pais"
	]
	set_format_dict('dream_es2', dream_es2_replacements[choice_log[1]])
	
	var regret_es2_replacements = [
		"buscar otro hogar para mis perros",
		"visitar el pueblo donde crecí",
		"despedirme de mis amigos",
		"apagar el horno",
		"borrar algunas cosas privadas de mi computadora",
		"donar mi colección de peluches",
		"gastar el resto de mis ahorros en pizza"
	]
	set_format_dict('regret_es2', regret_es2_replacements[choice_log[3]])
	
	# done
	
	emit_signal('start_dialog', 'natalie_post2', [])
