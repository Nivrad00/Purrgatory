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
	
	# chinese (placeholder)
	set_format_dict('dream_ch', choice_text[1])
	set_format_dict('regret_ch', choice_text[3])
		
	emit_signal('start_dialog', 'natalie_post2', [])
