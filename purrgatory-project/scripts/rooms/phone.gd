extends Control

const num_path = 'res://assets/sprites/numbers/'
var number = ''

func button_pressed(value):
	if $dial_tone.playing:
		$dial_tone.stop()
		
	if $busy_tone.playing:
		$busy_tone.stop()
		
	$click.play()
	
	if value == 'clear':
		for n in $numbers.get_children():
			n.queue_free()
		number = ''
	
	elif value == 'meow':
		$meow.play()
	
	elif value == 'dial':
		if number == '5555824387':
			emit_signal('start_dialog', 'phone_call', [])
		else:
			for n in $numbers.get_children():
				n.queue_free()
			number = ''
			$busy_tone.play()
	
	else:
		if number.length() >= 10:
			return
			
		var container = CenterContainer.new()
		container.rect_min_size = Vector2(40, 0)
		$numbers.add_child(container)
		
		var sprite = TextureRect.new()
		sprite.texture = load(num_path + value + '.png')
		container.add_child(sprite)
		
		if value == 'pound':
			number += '#'
		elif value == 'star':
			number += '*'
		else:
			number += value