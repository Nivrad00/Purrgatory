extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 2: 1 }
	ending_label = "end_flashback"
	
func wake_up():
	.wake_up()
	
	# all languages
	
	set_format_dict('partner_name', input_text[2])
	
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
	
	set_format_dict('partner_ch', replacements[choice_log[1]])
	set_format_dict('partner_about_ch', choice_text[3])
	
	# done 
	
	emit_signal('change_room', 'hallway1')
