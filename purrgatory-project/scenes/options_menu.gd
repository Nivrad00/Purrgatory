extends Control

signal options_changed()

var quips = [
	['cat', 'meow meow, meow meow meow :3'],
	['oliver', 'to meow, or not to meow, that is the question!'],
	['kyungsoon', 'hmmm. that\'s an options menu'],
	['numa', 'HEY!! change the font size right now! i mean... if you want.'],
	['sean', 'what\'s a nice player like you doing in a menu like this? (;'],
	['elijah', '\'tis better to have meowed and lost than never to have meowed at all.']
]

func options_changed():
	emit_signal('options_changed')

func show_custom():
	var state = get_node('/root/main/game').state
	
	var available_quips = [quips[0]]
	for quip in quips:
		if state.get('met_' + quip[0]):
			available_quips.append(quip)
			
	var current_quip = available_quips[randi() % available_quips.size()]
	$text_size/preview_a.set_text(current_quip[0])
	$text_size/preview_b.set_bbcode(current_quip[1])
	
	show()