extends 'state_handler_template.gd'

const num_path = 'res://assets/sprites/numbers/'
var number = ''
var state = null

func _ready():
	state = get_node('../../../../..').state
	
func init_state(_state):
	.init_state(_state)
	
	$dial_tone.play()
	
func update_state(_state):
	.update_state(_state)
	
	if _state.get('start_ringtone'):
		_state['start_ringtone'] = false
		$ringtone.play()
	if _state.get('end_ringtone'):
		_state['end_ringtone'] = false
		$ringtone.stop()
	if _state.get('phone_beep'):
		_state['phone_beep'] = false
		$busy_tone.play()
	if _state.get('phone_hang_up'):
		_state['phone_hang_up'] = false
		$hang_up.play()
		
	if _state.get('phone_nav'):
		$exit.hide()
		$three_cover.show()
	else:
		$exit.show()
		$three_cover.hide()
		
	if _state.get('phone_press_3'):
		_state['phone_press_3'] = false
		get_node('buttons/3/beep').play()
		button_pressed('3')
	
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
		if state.get('phone_nav'):
			return
			
		if number == '5555824387':
			emit_signal('start_dialog', 'phone_call', [])
		elif number == '911':
			emit_signal('start_dialog', 'phone_call_911', [])
		elif number == '112' and Language.language == 1: # spanish 911
			emit_signal('start_dialog', 'phone_call_911', [])
		elif number == '190' and Language.language == 5: # brazilian 911
			emit_signal('start_dialog', 'phone_call_911', [])
		else:
			$busy_tone.play()
		for n in $numbers.get_children():
			n.queue_free()
		number = ''
		
	else:
		if state.get('phone_nav'):
			if state.get('phone_nav2'):
				if value == '1':
					emit_signal('start_dialog', 'phone_call21', [])
				elif value == '2':
					emit_signal('start_dialog', 'phone_call22', [])
			else:
				if value == '1':
					emit_signal('start_dialog', 'phone_call1', [])
				elif value == '2':
					emit_signal('start_dialog', 'phone_call2', [])
			
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

func _on_three_cover_button_down():
	emit_signal('start_dialog', 'phone_call3', [])
