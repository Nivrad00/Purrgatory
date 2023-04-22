extends "TranslatedLabel.gd"

func _ready():
	._ready()
	
	var i = 0
	var quest_states = [
		'kyungsoon_quest_complete',
		'oliver_quest_complete',
		'numa_quest_complete',
		'elijah_quest_complete',
		'sean_quest_complete',
		'tori_quest_complete',
		'natalie_quest_complete'
	]
	for quest_state in quest_states:
		if get_tree().get_root().get_node('main/game').state.get(quest_state):
			i += 1
	
	translations = []
	if i == 1:
		translations.append("you saved 1 person")
		translations.append("salvaste a 1 persona")
		translations.append("(placeholder) you saved 1 person")
	elif i == 0:
		translations.append("you saved " + str(i) + " people")
		translations.append("salvaste a " + str(i) + " personas")
		translations.append("(placeholder) you saved " + str(i) + " people")
		
	update_label(Language.language)
