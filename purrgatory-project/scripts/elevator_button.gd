extends Button

var open = false

func _on_object_pressed():
	$button.play()
	if not $door.playing:
		$door.play()
	if open:
		get_node('../elevator_door1/AnimationPlayer').play_backwards('open')
		get_node('../exit2').hide()
		get_node('../door_dialog').show()
		open = false
	else:
		get_node('../elevator_door1/AnimationPlayer').play('open')
		get_node('../exit2').show()
		get_node('../door_dialog').hide()
		open = true

func door_finished(_a):
	$door.stop()
	$door_end.play()