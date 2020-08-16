extends 'state_handler_template.gd'

func erase():
	$paw/AnimationPlayer.play("shake")

func clear():
	$paw/draw/draw_viewport/pen.to_erase = true

func back():
	emit_signal('change_room', '_prev')
