extends 'state_handler_template.gd'

var dialog_map = {
	'game1': {
		'move1': 'ttt_now_you_go',
		'move2': 'ttt_hmm',
		'stalemate': 'ttt_stalemate1',
		'loss': 'ttt_loss1',
		'bad_move': 'ttt_bad1',
		'very_bad_move': 'ttt_very_bad1',
		'about_to_lose': 'ttt_about_to_lose1'
	},
	'game2': {
		'stalemate': 'ttt_stalemate2',
		'loss': 'ttt_loss2',
		'bad_move': 'ttt_bad2',
		'very_bad_move': 'ttt_very_bad2',
		'about_to_lose': 'ttt_about_to_lose2'
	},
	'game3': {
		'stalemate': 'ttt_stalemate3',
		'loss': 'ttt_loss3',
		'bad_move': 'ttt_bad3',
		'very_bad_move': 'ttt_very_bad3',
		'about_to_lose': 'ttt_about_to_lose3'
	},
	'game4': {
		'stalemate': 'ttt_stalemate4',
		'loss': 'ttt_loss4'
	},
	'game5': {
		'stalemate': 'ttt_stalemate5',
		'loss': 'ttt_loss5'
	}
}

var dialog_queue = []
var prev_score = 0

var game_num = 0
var move_num = 0
var current_board = null
var current_draw = null
var draw_freq = null
var draw_scene = preload("res://scenes/draw.tscn")

var audio_pos = 0

func update_state(state):
	.update_state(state)
		
	if state.get('ttt_init'):
		state['ttt_init'] = false
		start_game()
	if state.get('ttt_init_delay'):
		state['ttt_init_delay'] = false
		state['ttt_init'] = true
		
	if state.get('ttt_continue'):
		state['ttt_continue'] = false
		continue_game()
	if state.get('ttt_continue_delay'):
		state['ttt_continue_delay'] = false
		state['ttt_continue'] = true
		
	if state.get('ttt_goto_park'):
		state['ttt_goto_park'] = false
		emit_signal('change_room', 'field4')
		emit_signal('change_audio', null)
	if state.get('ttt_goto_meowseum'):
		state['ttt_goto_meowseum'] = false
		emit_signal('change_room', 'meowseum1')
		emit_signal('change_audio', null)
	if state.get('ttt_goto_dropoff'):
		state['ttt_goto_dropoff'] = false
		emit_signal('change_room', 'dropoff1')
		emit_signal('change_audio', null)

func start_game():
	set_process(true)
	
	game_num += 1
	move_num = 1 # it should start at 0 but oliver's first move is predetermined
	current_board = [1, 0, 0, 0, 0, 0, 0, 0, 0] # 0 = empty, 1 = oliver, 2 = player
	for draw in $draw_container.get_children():
		draw.queue_free()
	for shape in $shapes.get_children():
		shape.frame = 0
		shape.playing = false
	prev_score = 0
	$shapes.get_child(0).play()
	$asmr.play(audio_pos)

# the player uses this method, but not oliver
func start_audio(a, b):
	if not $asmr.playing:
		$asmr.play(audio_pos)
	$audio_delay.start()
	
# both the player and oliver use this method
func stop_audio():
	audio_pos = $asmr.get_playback_position()
	$asmr.stop()

func _process(delta):
	pass
	# print($audio_delay.time_left)
	
func start_olivers_turn():
	move_num += 1
	var best_move = get_best_move(current_board)
	var i = best_move[0]
	prev_score = best_move[1]
	$shapes.get_child(i).play()
	current_board[i] = 1
	$asmr.play(audio_pos)

func end_olivers_turn():
	$turn_delay.start()
	$audio_delay.start()
	
func end_olivers_turn2():
	if check_for_stalemate(current_board):
		end_game('stalemate')
	elif evaluate(current_board) == 10:
		end_game('loss')
	else:
		var i = 'game' + str(game_num)
		var j = 'move' + str(move_num)
		if prev_score == 8:
			if dialog_map[i].has('about_to_lose'):
				dialog_queue.append(dialog_map[i]['about_to_lose'])
		elif dialog_map.has(i) and dialog_map[i].has(j):
			dialog_queue.append(dialog_map[i][j])
		dialog_queue.append('players_turn')
		
		continue_game()
	
func start_players_turn():
	move_num += 1
	current_draw = draw_scene.instance()
	current_draw.enable()
	current_draw.connect('drew_line', self, 'start_audio')
	current_draw.connect('drew_line', self, 'record_freq')
	$draw_container.add_child(current_draw)
	$done_button.show()
	# $placeholder_input.show()
	draw_freq = [0, 0, 0, 0, 0, 0, 0, 0, 0]

func end_players_turn():
	current_draw.disable()
	# $placeholder_input.hide()
	$done_button.hide()
	
	var x = detect_players_move()
	current_board[x] = 2
	
	# note: it's not actually possible for the game to end after the player's turn
	var i = 'game' + str(game_num)
	var j = 'move' + str(move_num)
	
	var new_score = get_best_move(current_board)[1]
	if new_score == 10 and prev_score == 0:
		if dialog_map[i].has('very_bad_move'):
			dialog_queue.append(dialog_map[i]['very_bad_move'])
	elif new_score > 0 and prev_score == 0:
		if dialog_map[i].has('bad_move'):
			dialog_queue.append(dialog_map[i]['bad_move'])
		
	elif dialog_map.has(i) and dialog_map[i].has(j):
		dialog_queue.append(dialog_map[i][j])
	dialog_queue.append('olivers_turn')
	
	continue_game()

func continue_game():
	var next = dialog_queue.pop_front()
	if next == 'olivers_turn':
		start_olivers_turn()
	elif next == 'players_turn':
		start_players_turn()
	else:
		emit_signal('start_dialog', next, [])
	
func record_freq(start, end):
	var line = end - start
	var unit = line.normalized()
	
	for i in line.length():
		for j in range(9):
			if $spaces.get_child(j).get_rect().has_point(start + i * unit):
				draw_freq[j] += 1
	
	# print(draw_freq)
	
func detect_players_move():
	var square = -1
	var square2 = -1
	var freq = -1
	var freq2 = -1
	for i in range(9):
		if draw_freq[i] > freq:
			freq2 = freq
			freq = draw_freq[i]
			square2 = square
			square = i
		elif draw_freq[i] > freq2:
			freq2 = draw_freq[i]
			square2 = i
	return square
	#return int($placeholder_input.text)

func end_game(result):
	var i = 'game' + str(game_num)
	if dialog_map.has(i) and dialog_map[i].has(result):
		dialog_queue.append(dialog_map[i][result])
		
	continue_game()
	
# |
# |
# |
# dumb AI stuff below
# |
# |
# |

func check_for_stalemate(board):
	for square in board:
		if square == 0:
			return false
	return true
	
func evaluate(board):
	var sets = [
	  [0, 1, 2],
	  [3, 4, 5],
	  [6, 7, 8],
	  [0, 3, 6],
	  [1, 4, 7],
	  [2, 5, 8],
	  [0, 4, 8],
	  [2, 4, 6]
	]
	
	for set in sets:
		if board[set[0]] == board[set[1]] and board[set[1]] == board[set[2]]:
			if board[set[0]] == 1:
				return 10
			if board[set[0]] == 2:
				return -10
	return 0
  
func minimax(board, depth, is_max):
	var score = evaluate(board)
	if score == 10:
		return score - depth
	if score == -10:
		return score + depth
	if check_for_stalemate(board):
		return 0
		
	if is_max:
		var best = -1000
		for i in range(board.size()):
			if board[i] == 0:
				board[i] = 1
				best = max(best, minimax(board, depth + 1, false))
				board[i] = 0
		return best
		
	else:
		var best = 1000
		for i in range(board.size()):
			if board[i] == 0:
				board[i] = 2
				best = min(best, minimax(board, depth + 1, true))
				board[i] = 0
		return best
 
func get_best_move(board):
	var best_value = -1000
	var best_move = -1 
  
	for i in range(board.size()):
		if board[i] == 0:
			board[i] = 1
			var value = minimax(board, 0, false)
			board[i] = 0
			if value > best_value:
				best_value = value
				best_move = i
	return [best_move, best_value]