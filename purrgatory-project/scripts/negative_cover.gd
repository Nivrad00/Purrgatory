extends ColorRect

var fade = false
onready var negative_cover2 = get_node('../negative_cover2')

func fadeout():
	fade = true
	negative_cover2.show()
	hide()

func _process(delta):
	if fade:
		if negative_cover2.modulate.a == 0:
			negative_cover2.hide()
			negative_cover2.modulate.a = 1
			fade = false
		else: 
			negative_cover2.modulate.a = max(0, negative_cover2.modulate.a - delta)
