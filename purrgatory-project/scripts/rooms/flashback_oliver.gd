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
	
func update_state(state):
	.update_state(state)
	if state.get('flashback_goto_commons'):
		emit_signal('change_room', 'commons1')
