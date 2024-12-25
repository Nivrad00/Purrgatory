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

	# italian
	
	var role_model_it_replacements = [
		"una persona estranea alla famiglia",
		"un amico d'infanzia che si è trasferito",
		"un'artista che ho conosciuto online",
		"una professoressa alla mano del liceo",
		"un bassista di una band ignota",
		"il personaggio di una serie tv",
		"la mia migliore amica"
	]
	set_format_dict('role_model_it', role_model_it_replacements[choice_log[1]])
	
	var envy_it_replacements = [
		"l'intelligenza",
		"l'altruismo",
		"il coraggio",
		"la compassione",
		"il successo",
		"il talento",
		"la saggezza"
	]
	set_format_dict('envy_it', envy_it_replacements[choice_log[2]])
	
	# polish
	
	var role_model_pl_replacements = [
		"odległy członek rodziny",
		"przyjaciel z dzieciństwa, który się wyprowadził",
		"artysta poznany online",
		"twardo stąpający po ziemi nauczyciel z liceum",
		"basista z mało znanego zespołu",
		"bohater mojego ulubionego serialu",
		"mój najbliższy przyjaciel"
	]
	set_format_dict('role_model_pl', role_model_pl_replacements[choice_log[1]])
	
	var envy_pl_replacements = [
		"inteligentny",
		"bezinteresowny",
		"odważny",
		"współczujący",
		"popularny",
		"utalentowany",
		"mądry"
	]
	set_format_dict('envy_pl', envy_pl_replacements[choice_log[2]])
	
	# portuguese
	
	var role_model_pt_replacements = [
		"um parente distante",
		"um amigo de infância que se distanciou",
		"um artista que eu conheci online",
		"um professor diferenciado do ensino médio",
		"um baixista de uma banda obscura",
		"um personagem do meu show de tv favorito",
		"meu amigo mais próximo"
	]
	set_format_dict('role_model_pt', role_model_pt_replacements[choice_log[1]])
	
	var envy_pt_replacements = [
		"inteligente",
		"autruísta",
		"valente",
		"compassiva",
		"sussedida",
		"talentosa",
		"sabia"
	]
	set_format_dict('envy_pt', envy_pt_replacements[choice_log[2]])
	
	# latam spanish
	
	var role_model_es2_replacements = [
		"un familiar distanciado",
		"un amigo de la infancia que se mudó muy lejos",
		"un artista que conocí por internet",
		"un profesor de la escuela que tenía los pies en la tierra",
		"un bajista de una banda dark",
		"un personaje de mi serie favorita de televisión",
		"mi amigo más cercano"
	]
	set_format_dict('role_model_es2', role_model_es2_replacements[choice_log[1]])
	
	var envy_es2_replacements = [
		"inteligente",
		"altruista",
		"valiente",
		"sensible",
		"hábil",
		"perspicaz",
		"prudente"
	]
	set_format_dict('envy_es2', envy_es2_replacements[choice_log[2]])
	
	# done
	
	emit_signal('change_room', 'flashback_sean')
