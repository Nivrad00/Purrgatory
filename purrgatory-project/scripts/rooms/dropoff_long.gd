extends 'state_handler_template.gd'

var time = 0 # time elapsed
var progress = 0 # distance down the hole
var climb_speed = 150 # how fast player climbs down

var fall_time = 0 # used when the post cracks - how long player falls for
var fall_accel = 5000
var velocity = 0 # player's velocity while falling

var climbing = false # climbing minigame
var pull_speed = 500 # how fast tori pulls player up
var base_drain_speed = 10
var recover_amount = 4
var dialog_timing = [-8500, -6600, -4700, -2800, -900]
var used_dialog = [false, false, false, false, false]

var lost_grip = false

func _ready():
	set_process(true)

func _input(event):
	if climbing and event is InputEventKey and event.pressed and event.get_scancode() == KEY_UP:
		$_game/ProgressBar.value += recover_amount
		
func _process(delta):
	if fall_time > 0:
		if fall_time > delta:
			velocity += delta * fall_accel
			fall_time -= delta
			for node in get_children():
				if node.name.substr(0, 1) != '_':
					node.position.y -= delta * velocity
				
		else:
			velocity += fall_time * fall_accel
			for node in get_children():
				if node.name.substr(0, 1) != '_':
					node.position.y -= fall_time * velocity
			fall_time = 0
			
		if fall_time == 0:
			get_node('../../../../ui/text_box').disabled = false
			
	if get_node('../../../../ui').visible or get_node('../../../../../meta_ui/pause_menu').visible:
		return
	
	if lost_grip:
		time += delta
		if int(time * 10) % 12 < 8:
			for node in get_children():
				if node.name.substr(0, 1) != '_':
					node.position.y = min(0, node.position.y + delta * pull_speed)
		
		progress = $bg.position.y
		if progress == 0:
			emit_signal('start_dialog', 'tori_climb_return', [])
		
	elif climbing:
		time += delta
		var drain_speed = base_drain_speed + 30 * (1 + progress / 10000)
		$_game/ProgressBar.value -= delta * drain_speed
		
		if int(time * 10) % 12 < 8:
			for node in get_children():
				if node.name.substr(0, 1) != '_':
					node.position.y = min(0, node.position.y + delta * pull_speed)
		
		for i in range(0, 5):
			if $bg.position.y >= dialog_timing[i] and progress < dialog_timing[i] and not used_dialog[i]:
				$_dialog.get_node(str(i)).show()
				used_dialog[i] = true
			elif $bg.position.y >= dialog_timing[i] + 700 and progress < dialog_timing[i] + 700:
				$_dialog.get_node(str(i)).hide()
			
		progress = $bg.position.y
		
		if progress == 0:
			$_game.hide()
			emit_signal('start_dialog', 'tori_climb_return', [])
		
		elif $_game/ProgressBar.value == 0:
			for dialog in $_dialog.get_children():
				dialog.hide()
				
			fall_time = 1
			velocity = 0
			lost_grip = true
			climbing = false
			$_game.hide()
			emit_signal('start_dialog', 'tori_climb_fall', [])
	
	else:
		if Input.is_action_pressed('ui_down') and not Input.is_action_pressed('ui_up')\
		and $bg.position.y >= -9280:
			time += delta
			if int(time * 10) % 12 < 8:
				for node in get_children():
					if node.name.substr(0, 1) != '_':
						node.position.y -= delta * climb_speed
					
		elif Input.is_action_pressed('ui_up') and not Input.is_action_pressed('ui_down')\
		and $bg.position.y <= 0:
			time += delta
			if int(time * 10) % 12 < 8:
				for node in get_children():
					if node.name.substr(0, 1) != '_':
						node.position.y += delta * climb_speed
		else:
			time = 0
			
		var position = $bg.position.y
		if progress > position:
			if progress > -1000 and position < -1000:
				emit_signal('start_dialog', 'tori_climb1', [])
			elif progress > -3500 and position < -3500:
				emit_signal('start_dialog', 'tori_climb2', [])
			elif progress > -7000 and position < -7000:
				emit_signal('start_dialog', 'tori_climb3', [])
			elif progress > -8500 and position < -8500:
				emit_signal('start_dialog', 'tori_climb4', [])
			progress = position
	
func init_state(state):
	.init_state(state)
	emit_signal('start_dialog', 'tori_climb0', [])

func update_state(state):
	.update_state(state)
	if state.get('turn_on_flashlight'):
		state['turn_on_flashlight'] = false
		$_flashlight.show()
	
	if state.get('climb_crack1'):
		state['climb_crack1'] = false
		fall_time = 0.1
		velocity = 0
		
	elif state.get('climb_crack2'):
		state['climb_crack2'] = false
		fall_time = 0.4
		velocity = 0
	
	if state.get('start_climb_game'):
		climbing = true
		state['start_climb_game'] = false
		$_game.show()
		$object.hide()
		$object2.hide()
		$object3.hide()