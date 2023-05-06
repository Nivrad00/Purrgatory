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
	
	# done 
	
	emit_signal('change_room', 'hallway1')
