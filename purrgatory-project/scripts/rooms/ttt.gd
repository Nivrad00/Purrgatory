extends 'state_handler_template.gd'

var dialog_map = {
	'game1': {
		'move1': 'ttt_now_you_go',
		'move4': 'ttt_test1',
		'move8': 'ttt_test2',
		'stalemate': 'ttt_stalemate1',
		'loss': 'ttt_loss1'
	},
	'bad_move': 'ttt_bad'
}
var current_board
var current_draw = null
var draw_freq = null
var draw_scene = preload("res://scenes/draw.tscn")

func update_state(state):
	.update_state(state)
	if state.get('ttt_init'):
		start_game()
	if state.get('ttt_init_delay'):
		state['ttt_init_delay'] = false
		state['ttt_init'] = true
		
func start_game():
	current_board = [1, 0, 0, 0, 0, 0, 0, 0, 0] # 0 = empty, 1 = oliver, 2 = player
	$shapes.get_child(0).play()
	
func start_olivers_turn():
	var i = get_best_move(current_board)
	$shapes.get_child(i).play()
	current_board[i] = 1

func end_olivers_turn():
	$turn_delay.start()
	
func end_olivers_turn2():
	if check_for_stalemate(current_board) or evaluate(current_board) != 0:
		end_game()
	else:
		start_players_turn()
	
func start_players_turn():
	current_draw = draw_scene.instance()
	current_draw.enable()
	current_draw.connect('drew_line', self, 'record_freq')
	$draw_container.add_child(current_draw)
	$done_button.show()
	# $placeholder_input.show()
	draw_freq = [0, 0, 0, 0, 0, 0, 0, 0, 0]

func end_players_turn():
	current_draw.disable()
	# $placeholder_input.hide()
	$done_button.hide()
	
	var i = detect_players_move()
	current_board[i] = 2
	
	if check_for_stalemate(current_board) or evaluate(current_board) != 0:
		end_game()
	else:
		start_olivers_turn()

func record_freq(start, end):
	var line = end - start
	var unit = line.normalized()
	
	for i in line.length():
		for j in range(9):
			if $spaces.get_child(j).get_rect().has_point(start + i * unit):
				draw_freq[j] += 1
	
	print(draw_freq)
	
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

func end_game():
	print('game over!')

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
	return best_move