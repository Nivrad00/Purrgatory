extends Label

func _ready():	
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
	
	if i == 1:
		text = tr("YOU_SAVED_SINGULAR")
	else:
		text = tr("YOU_SAVED_PLURAL")
		text = text.replace("#", str(i))
