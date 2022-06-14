extends "flashback_template.gd"

func _ready():
	._ready()
	ending_label = null

func wake_up():
	.wake_up()
	
	# english
	
	var replacements = [
		'an estranged family member',
		'a childhood friend',
		'an artist',
		'a high school teacher',
		'a bassist in this band i liked',
		'a character from this tv show i liked',
		'my closest friend'
	]
	set_format_dict('role_model', replacements[choice_log[1]])
	set_format_dict('envy', choice_text[2])
	
	# spanish
	
	var role_model_es_replacements = [
		'un familiar con el que perdí el contacto',
		'una amiga de la infancia que se mudó lejos',
		'une artista que seguía',
		'una profesora con los pies en la tierra',
		'le bajista de una banda que me gustaba',
		'un personaje de mi serie favorita',
		'mi mejor amigx'
	]
	set_format_dict('role_model_es', role_model_es_replacements[choice_log[1]])
	
	var envy_es_replacements = [
		'inteligente',
		'altruista',
		'valiente',
		'sensible',
		'hábil',
		'perspicaz',
		'prudente'
	]
	set_format_dict('envy_es', envy_es_replacements[choice_log[2]])
	
	# done
	
	emit_signal('change_room', 'flashback_sean')
