extends 'state_handler_template.gd'

var time = 0 # time elapsed
var progress = 0 # distance down the hole
var climb_speed = 150 # how fast player climbs down

var fall_time = 0 # used when the post cracks - how long player falls for
var rise_time = 0 # the bounce back from falling
var fall_accel = 4000
var rise_accel = 10000
var velocity = 0 # player's velocity while falling

var climbing = false # climbing minigame
var pull_speed = 500 # how fast tori pulls player up
var base_drain_speed = 10
var recover_amount = 4
var dialog_timing = [-8500, -6600, -4700, -2800, -900]
var used_dialog = [false, false, false, false, false]
var creak_num = 0

var lost_grip = false
var key_down = false

func _ready():
	set_process(true)

func _input(event):
	if climbing and not key_down and event is InputEventKey and event.pressed and event.get_scancode() == KEY_UP:
		$_game/ProgressBar.value += recover_amount
		key_down = true
		
	elif climbing and key_down and event is InputEventKey and not event.pressed and event.get_scancode() == KEY_UP:
		key_down = false
		
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
			if $_falling.playing:
				$_falling.stop()
				$_stop.play()
				rise_time = 0.25
				velocity = 2000
	
	if rise_time > 0:
		if rise_time > delta:
			velocity -= delta * rise_accel
			rise_time -= delta
			for node in get_children():
				if node.name.substr(0, 1) != '_':
					node.position.y -= delta * velocity
				
		else:
			velocity -= rise_time * rise_accel
			for node in get_children():
				if node.name.substr(0, 1) != '_':
					node.position.y -= rise_time * velocity
			rise_time = 0
		
	if get_node('../../../../ui').visible or get_node('../../../../../meta_ui/pause_menu').visible:
		return
	
	if lost_grip:
		var prev_time = time
		time += delta
		
		if int(time * 10) % 12 < 8:
			for node in get_children():
				if node.name.substr(0, 1) != '_':
					node.position.y = min(0, node.position.y + delta * pull_speed)
			
			if int(prev_time * 10) % 12 >= 8 or prev_time == 0:
				creak_num = (creak_num + 1) % 6
				$_pulls.get_child(creak_num).play()
		
		for i in range(0, 5):
			if $bg.position.y >= dialog_timing[i] and progress < dialog_timing[i] and not used_dialog[i]:
				$_dialog.get_node(str(i)).show()
				used_dialog[i] = true
			elif $bg.position.y >= dialog_timing[i] + 700 and progress < dialog_timing[i] + 700:
				$_dialog.get_node(str(i)).hide()
				
		progress = $bg.position.y
		if progress == 0:
			emit_signal('start_dialog', 'tori_climb_return', [])
		
			
	elif climbing:
		var prev_time = time
		time += delta
		
		var drain_speed = base_drain_speed + 30 * (1 + progress / 10000)
		$_game/ProgressBar.value -= delta * drain_speed
		
		if int(time * 10) % 12 < 8:
			for node in get_children():
				if node.name.substr(0, 1) != '_':
					node.position.y = min(0, node.position.y + delta * pull_speed)
					
			if int(prev_time * 10) % 12 >= 8 or prev_time == 0:
				creak_num = (creak_num + 1) % 6
				$_pulls.get_child(creak_num).play()
		
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
				
			fall_time = 1.5
			velocity = 0
			lost_grip = true
			climbing = false
			$_game.hide()
			emit_signal('start_dialog', 'tori_climb_fall', [])
			$_falling.play()
			time = 0
	
	else:
		if Input.is_action_pressed('ui_down') and not Input.is_action_pressed('ui_up')\
		and $bg.position.y >= -9280:
			var prev_time = time
			time += delta
			if int(time * 10) % 12 < 8:
				for node in get_children():
					if node.name.substr(0, 1) != '_':
						node.position.y -= delta * climb_speed
						
				if int(prev_time * 10) % 12 >= 8 or prev_time == 0:
					creak_num = (creak_num + 1) % 6
					$_creaks.get_child(creak_num).play()
					
		elif Input.is_action_pressed('ui_up') and not Input.is_action_pressed('ui_down')\
		and $bg.position.y <= 0:
			var prev_time = time
			time += delta
			if int(time * 10) % 12 < 8:
				for node in get_children():
					if node.name.substr(0, 1) != '_':
						node.position.y += delta * climb_speed
						
				if int(prev_time * 10) % 12 >= 8 or prev_time == 0:
					creak_num = (creak_num + 1) % 6
					$_creaks.get_child(creak_num).play()
		else:
			time = 0
			
		var position = $bg.position.y
		if progress > position:
			if progress > -1000 and position < -1000:
				emit_signal('start_dialog', 'tori_climb1', [])
				time = 0
			elif progress > -3500 and position < -3500:
				emit_signal('start_dialog', 'tori_climb2', [])
				time = 0
			elif progress > -7000 and position < -7000:
				emit_signal('start_dialog', 'tori_climb3', [])
				time = 0
			elif progress > -8500 and position < -8500:
				emit_signal('start_dialog', 'tori_climb4', [])
				time = 0
			progress = position
	
func init_state(state):
	.init_state(state)
	emit_signal('start_dialog', 'tori_climb0', [])
	$tori_after.hide()
	$tori_before.show()

func update_state(state):
	.update_state(state)
	if state.get('turn_on_flashlight') and not $_flashlight.visible:
		$_flashlight.show()
	
	if state.get('climb_crack1'):
		state['climb_crack1'] = false
		$_cracks/a.play()
		
		fall_time = 0.1
		velocity = 0
		
		$_crack_delay.wait_time = 0.42
		$_crack_delay.start()
		yield($_crack_delay, "timeout")
		
		fall_time = 0.2
		velocity = 0
		
	elif state.get('climb_crack2'):
		state['climb_crack2'] = false
		
		fall_time = 0.1
		velocity = 0
		
		$_cracks/b.play()
		$_crack_delay.wait_time = 0.18
		$_crack_delay.start()
		yield($_crack_delay, "timeout")
		
		fall_time = 0.4
		velocity = 0
	
	if state.get('start_climb_game'):
		climbing = true
		state['start_climb_game'] = false
		$_game.show()
		$snowglobe_dropoff.hide()
		$object2.hide()
		$object3.hide()
		$tori_after.show()
		$tori_before.hide()
		time = 0
		
	if state.get('_inv_snowglobe_dropoff') or state.get('spent_snowglobes'):
		$snowglobe_dropoff.hide()

func load_in(_climbing, _lost_grip, _progress, _stamina):
	climbing = _climbing
	lost_grip = _lost_grip
	progress = _progress
	$_game/ProgressBar.value = _stamina
	
	for node in get_children():
		if node.name.substr(0, 1) != '_':
			node.position.y += progress
			
	if lost_grip:
		$snowglobe_dropoff.hide()
		$object2.hide()
		$object3.hide()
		$tori_after.show()
		$tori_before.hide()
	elif climbing:
		$_game.show()
		$snowglobe_dropoff.hide()
		$object2.hide()
		$object3.hide()
		$tori_after.show()
		$tori_before.hide()
		
		