extends Control

onready var tts_node = get_node('../../tts_node')
onready var ui = get_node('../../content/ui')
onready var game = get_node('../..')

func show_custom():
	if game.state.get('kyungsoon_quest_complete'):
		$icons/kyungsoon1.hide()
		$icons/kyungsoon2.show()
	elif game.state.get('met_kyungsoon'):
		$icons/kyungsoon1.show()
		$icons/kyungsoon2.hide()
	else:
		$icons/kyungsoon1.hide()
		$icons/kyungsoon2.hide()
		
	if game.state.get('oliver_quest_complete'):
		$icons/oliver1.hide()
		$icons/oliver2.show()
	elif game.state.get('met_oliver'):
		$icons/oliver1.show()
		$icons/oliver2.hide()
	else:
		$icons/oliver1.hide()
		$icons/oliver2.hide()
		
	if game.state.get('numa_quest_complete'):
		$icons/numa1.hide()
		$icons/numa2.show()
	elif game.state.get('met_numa'):
		$icons/numa1.show()
		$icons/numa2.hide()
	else:
		$icons/numa1.hide()
		$icons/numa2.hide()
		
	if game.state.get('elijah_quest_complete'):
		$icons/elijah1.hide()
		$icons/elijah2.show()
	elif game.state.get('met_elijah'):
		$icons/elijah1.show()
		$icons/elijah2.hide()
	else:
		$icons/elijah1.hide()
		$icons/elijah2.hide()
		
	if game.state.get('sean_quest_complete'):
		$icons/sean1.hide()
		$icons/sean2.show()
	elif game.state.get('met_sean'):
		$icons/sean1.show()
		$icons/sean2.hide()
	else:
		$icons/sean1.hide()
		$icons/sean2.hide()
		
	if game.state.get('tori_quest_complete'):
		$icons/tori1.hide()
		$icons/tori2.show()
	elif game.state.get('met_tori'):
		$icons/tori1.show()
		$icons/tori2.hide()
	else:
		$icons/tori1.hide()
		$icons/tori2.hide()
		
	if game.state.get('natalie_quest_complete'):
		$icons/natalie1.hide()
		$icons/natalie2.show()
	elif game.state.get('met_natalie'):
		$icons/natalie1.show()
		$icons/natalie2.hide()
	else:
		$icons/natalie1.hide()
		$icons/natalie2.hide()
	
	var empty = true
	for node in $icons.get_children():
		if node.visible:
			empty = false
			break
	
	if empty:
		$buttons.rect_position.y = -54
	else:
		$buttons.rect_position.y = 0
		
		
	show()

func hide_custom():
	ui.speak_ui()
	hide()
