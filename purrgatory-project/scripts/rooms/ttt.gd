extends 'state_handler_template.gd'

var current_board

func _ready():
	pass

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
	$done_button.show()
	$draw.show()

func end_players_turn():
	$draw.hide()
	$done_button.hide()
	
	var i = detect_players_move()
	$shapes.get_child(i).play()
	$shapes.get_child(i).modulate.a = 0.2
	
	current_board[i] = 2
	if check_for_stalemate(current_board) or evaluate(current_board) != 0:
		end_game()
	else:
		start_olivers_turn()

func detect_players_move():
	# palceholder algorithm
	return int($draw.text)

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