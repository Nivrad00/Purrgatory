extends 'state_handler_template.gd'

var flower_button = load('res://scenes/sprites/flower_button.tscn')
var max_id = 46
var num_flowers = 70
var num_targets = 8
var flower_min_dist = 40
var game_duration = 75
var flowers = []
var grid_interval = 10

var grid
var x_start
var y_start
var x_length
var y_length

var target_ids = []

var start_flag = false
var paused = false

func _ready():
	$flower_box.hide()
	$flower_timer.hide()
	$flower_progress.hide()
	set_process(true)
	# debug
	# randomize()
	# init_state({})

func _process(delta):
	if not paused and (get_node('../../../../ui').visible or get_node('../../../../../meta_ui/pause_menu').visible):
		$flower_timer/AnimationPlayer.stop(false)
		$game_timer.paused = true
		paused = true
	elif paused and not (get_node('../../../../ui').visible or get_node('../../../../../meta_ui/pause_menu').visible):
		$flower_timer/AnimationPlayer.play()
		$game_timer.paused = false
		paused = false
		
func start_game(time_left = 0, progress = 0):
	emit_signal('change_audio', 'Frantic_Flowers')
	$flower_timer.show()
	$flower_box.show()
	$flower_progress.show()
	
	for i in range(progress):
		target_ids.pop_front()
		$flower_progress.increment()
		reset_indicator()
	
	$flower_timer/AnimationPlayer.set_speed_scale(1.6 / game_duration)
	$flower_timer/AnimationPlayer.play("New Anim")
	if time_left > 0:
		$flower_timer/AnimationPlayer.seek(1.6 * (game_duration - time_left) / game_duration, true)
	
	if time_left == 0:
		$game_timer.start(game_duration)
	else:
		$game_timer.start(time_left)
	
func failure():
	$flower_timer/AnimationPlayer.stop(false)
	emit_signal('start_dialog', 'flowers_fail', null)
	emit_signal('change_audio', '')
		
func success():
	$success.play()
	$game_timer.stop()
	$flower_timer/AnimationPlayer.stop(false)
	$flower_box.set_indicator('success')
	emit_signal('start_dialog', 'flowers_succeed', null)
	emit_signal('change_audio', '')
	
func pick_flower(id):			
	# print('picked' + str(id))
	if !target_ids.empty():
		if id == target_ids[0]:
			target_ids.pop_front()
			$flower_progress.increment()
			if target_ids.empty():
				success()
			else:
				$yes.play()
				$flower_box.set_indicator('check')
				$indicator_timer.set_wait_time(1)
				$indicator_timer.start()
		else:
			$no.play()
			$flower_box.set_indicator('x')
			$indicator_timer.set_wait_time(1)
			$indicator_timer.start()

func reset_indicator():
	if target_ids.size() > 0:
		$flower_box.set_indicator(target_ids[0])

		
func index_to_coords(i):
	var row = floor(i / x_length)
	var col = i % x_length
	return [row, col]
		
func coords_to_index(row, col):
	return row * x_length + col

func generate_flowers(ids):
	for id in ids:
		var origin_index = grid.keys()[randi() % grid.size()]
		
		# remove all nearby squares in grid
		var origin_coords = index_to_coords(origin_index)
		for row in range(origin_coords[0] - flower_min_dist / grid_interval, origin_coords[0] + flower_min_dist / grid_interval + 1):
			if row < 0 or row >= y_length:
				continue
			for col in range(origin_coords[1] - flower_min_dist / grid_interval, origin_coords[1] + flower_min_dist / grid_interval + 1):
				if col < 0 or col >= x_length:
					continue
				grid.erase(coords_to_index(row, col))
		
		var flower = flower_button.instance()
		flower.connect('pick_flower', self, 'pick_flower')
		flower.set_id(id)
		flower.set_position(Vector2(x_start + origin_coords[1] * grid_interval, y_start + origin_coords[0] * grid_interval))
		flowers.append(flower)
		
func init_state(state):
	.init_state(state)
	
	var start = OS.get_ticks_usec()
	setup_game()
	var end = OS.get_ticks_usec()
	# print('algo 2: ' + str((end-start)/1000000.0))

func setup_game():
	
	var flower_width = 40 # just an estimate
	var area = $flower_area.get_rect()
	x_start = int(area.position.x)
	x_length = int((area.end.x - flower_width - x_start) / grid_interval)
	y_start = int(area.position.y)
	y_length = int((area.end.y - y_start) / grid_interval)
	
	# generate grid of all possible coordinates
	grid = {} # dictionary for hashing
	for i in range(x_length * y_length):
		grid[i] = true
			
	for i in range(num_targets):
		var new_id = null
		while true:
			new_id = randi() % (max_id + 1)
			if not new_id in target_ids:
				break
		target_ids.append(new_id)
	
	generate_flowers(target_ids)
	
	var other_ids = []
	for id in range(max_id + 1):
		if not id in target_ids:
			other_ids.append(id)
			
	var random_ids = []
	for i in range(num_flowers - target_ids.size()):
		random_ids.append(other_ids[randi() % other_ids.size()])
		
	generate_flowers(random_ids)
	
	flowers.invert()
	
	for flower in flowers:
		$flower_sorter.add_child(flower)
	$flower_box.set_indicator(target_ids[0])
	
	
func update_state(state):
	.update_state(state)
	
	if start_flag == true:
		start_game()
		start_flag = false
		state['flower_ongoing'] = true
		
	if state.get('flowers_goto_garden'):
		emit_signal('change_room', 'garden6')
	if state.get('flower_start_flag'):
		start_flag = true
		state['flower_start_flag'] = false
	
	if state.get('increment_flower_fails'):
		state['flower_ongoing'] = false
		state['increment_flower_fails'] = false
		state['flower_fails'] += 1
	
	if state.get('numa_finished_flowers') and state.get('flower_ongoing'):
		state['flower_ongoing'] = false
		
