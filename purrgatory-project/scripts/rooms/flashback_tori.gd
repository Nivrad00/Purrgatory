extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 2: 1, 3: 1 }
	ending_label = "end_flashback"

func init_state(state):
	.init_state(state)
	state['tori_quest_complete'] = true
	state['queue_tori_flashback'] = false
	
func wake_up():
	.wake_up()
	emit_signal('change_room', 'warehouse3')
	
	set_format_dict('desire', choice_text[1])
	
	var desire_es_replacements = [
		'el conocimiento',
		'la amistad',
		'la aventura',
		'la destreza',
		'la felicidad',
		'la libertad',
		'el amor'
	]
	set_format_dict('desire_es', desire_es_replacements[choice_log[1]])
	
	var desire_ch_replacements = [
		'知识',
		'友谊',
		'冒险',
		'技能',
		'幸福',
		'自由',
		'爱情'
	]
	set_format_dict('desire_ch', desire_ch_replacements[choice_log[1]])
	
	var desire_it_replacements = [
		"il sapere",
		"l'amicizia",
		"l'avventura",
		"il talento",
		"la felicità",
		"la libertà",
		"l'amore"
	]
	set_format_dict('desire_it', desire_it_replacements[choice_log[1]])
	
	var desire_pl_replacements = [
		"wiedza",
		"przyjaźń",
		"przygody",
		"umiejętności",
		"szczęście",
		"wolność",
		"miłość"
	]
	set_format_dict('desire_pl', desire_pl_replacements[choice_log[1]])
	
	var desire_pt_replacements = [
		"conhecimento",
		"amizade",
		"aventura",
		"habilidade",
		"felicidade",
		"liberdade",
		"amor"
	]
	set_format_dict('desire_pt', desire_pt_replacements[choice_log[1]])
	
	var desire_es2_replacements = [
		"conocimiento",
		"amistades",
		"aventuras",
		"destreza",
		"felicidad",
		"libertad",
		"amor"
	]
	set_format_dict('desire_es2', desire_es2_replacements[choice_log[1]])
	
