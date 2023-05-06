 extends "flashback_template.gd"

func _ready():
	._ready()
	ending_label = null

func wake_up():
	.wake_up()
	
	# english
	# note: the direct "choice_text[n]" approach only works for english, since the choice texts are saved in english
	# for all the other languages you have to do "replacements[choice_log[n]]" instead
	# (for context. in english you only hvae to do "replacements...etc" if the wording in the lucifur interview is 
	#    different from the wording in the flashback)
	
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
	
	# chinese (placeholder)
	
	var role_model_ch_replacements = [
		'我的远房亲戚',
		'我的儿时玩伴',
		'是个网上的艺术家',
		'我那接地气的高中老师',
		'有个乐队的贝斯手',
		'是我最喜欢的电视剧角色',
		'我最亲近的朋友'
	]
	set_format_dict('role_model_ch', role_model_ch_replacements[choice_log[1]])
	
	var envy_ch_replacements = [
		'聪慧',
		'无私',
		'勇敢',
		'慈爱',
		'成功',
		'有才',
		'明智'
	]
	set_format_dict('envy_ch', envy_ch_replacements[choice_log[2]])
	
	# done
	
	emit_signal('change_room', 'flashback_sean')
