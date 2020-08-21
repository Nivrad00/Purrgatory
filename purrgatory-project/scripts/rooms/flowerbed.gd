extends 'state_handler_template.gd'

var flower_button = load('res://scenes/sprites/flower_button.tscn')
var max_id = 46
var num_flowers = 70
var num_targets = 8
var flower_min_dist = 50
var game_duration = .75
var flowers = []

var target_ids = []

var start_flag = false

func _ready():
	$flower_box.hide()
	$flower_timer.hide()
	$flower_progress.hide()
	# debug
	# randomize()
	# init_state({})

func start_game():
	$game_timer.wait_time = game_duration
	$flower_timer.show()
	$flower_box.show()
	$flower_progress.show()
	
	$flower_timer/AnimationPlayer.set_speed_scale(1.6 / game_duration)
	$flower_timer/AnimationPlayer.play("New Anim")
	$game_timer.start()
	
func failure():
	$flower_timer/AnimationPlayer.stop(false)
	emit_signal('start_dialog', 'flowers_fail', null)
		
func success():
	$success.play()
	$game_timer.stop()
	$flower_timer/AnimationPlayer.stop(false)
	$flower_box.set_indicator('success')
	emit_signal('start_dialog', 'flowers_succeed', null)
	
func pick_flower(id):
	print('picked' + str(id))
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
	$flower_box.set_indicator(target_ids[0])

func generate_flowers(ids):
	for id in ids:
		var flower = flower_button.instance()
		flower.connect('pick_flower', self, 'pick_flower')
		flower.set_id(id)
		
		var size = flower.get_normal_texture().get_size()
		var area = $flower_area.get_rect()
		var pos = null
		
		while true:
			var x = rand_range(area.position.x - size.x / 4, area.end.x - size.x * 3/4)
			var y = rand_range(area.position.y - size.y, area.end.y - size.y)
			pos = Vector2(x, y)
			var valid_pos = true
			for flower in flowers:
				if flower.get_position().distance_to(pos) < flower_min_dist:
					valid_pos = false
			if valid_pos:
				break
			
		flower.set_position(pos)
		flowers.append(flower)
		
func init_state(state):
	.init_state(state)
	
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
	
	for flower in flowers:
		$flower_sorter.add_child(flower)
	$flower_box.set_indicator(target_ids[0])

func update_state(state):
	.update_state(state)
	
	if start_flag == true:
		start_game()
		start_flag = false
	if state.get('flowers_goto_garden'):
		emit_signal('change_room', 'garden6')
	if state.get('flower_start_flag'):
		start_flag = true
		state['flower_start_flag'] = false
	
	if state.get('increment_flower_fails'):
		state['increment_flower_fails'] = false
		state['flower_fails'] += 1
		print(state['flower_fails'])