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
		
	emit_signal('start_dialog', 'natalie_post2', [])
