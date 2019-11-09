extends 'state_handler_template.gd'

var board

func _ready():
	pass # Replace with function body.

func update_state(state):
	.update_state(state)
	if state.get('ttt_init'):
		start_game()
	if state.get('ttt_init_delay'):
		state['ttt_init_delay'] = false
		state['ttt_init'] = true
		
func start_game():
	board = [0, 0, 0, 0, 0, 0, 0, 0, 0] # 0 = empty, 1 = oliver, 2 = player
	start_olivers_turn()
	
func start_olivers_turn():
	var i = get_best_move()
	$shapes.get_child(i).play()
	board[i] = 1

func end_olivers_turn():
	if check_for_three():
		end_game()
	else:
		start_players_turn()
	
func start_players_turn():
	$done_button.show()

func end_players_turn():
	var i = detect_players_move()
	board[i] = 2
	if check_for_three():
		end_game()
	else:
		start_olivers_turn()
	
func get_best_move():
	# palceholder algorithm, returns the first empty square
	for i in range(9):
		if board[i] == 0:
			return i

func detect_players_move():
	# palceholder algorithm, returns the first empty square
	for i in range(9):
		if board[i] == 0:
			return i

func check_for_three():
	return false

func end_game():
	pass