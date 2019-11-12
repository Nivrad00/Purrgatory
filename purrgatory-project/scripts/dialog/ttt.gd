extends Node

var raw_blocks = [
["ttt_init","_none","_none","oliver pulls a pencil out of his pocket and draws a board.","oliver_goto_ttt","","","",""],
["","oliver","","i'll go first.","ttt_init_delay","","null","",""],
["ttt_now_you_go","oliver","_none","okay, now you draw an O anywhere on the board.","","","","",""],
["","you","","i know how to play tic-tac-toe!","","","","",""],
["","oliver","","right, right, sorry","ttt_continue_delay","","null","",""],
["ttt_hmm","oliver","_none","hmm...","ttt_continue_delay","","null","",""],
["ttt_test1","you","_none","test1","ttt_continue_delay","","null","",""],
["ttt_test2","you","_none","test2","ttt_continue_delay","","null","",""],
["ttt_test3","you","_none","test3","ttt_continue_delay","","null","",""],
["ttt_stalemate1","oliver","_none","that's a stalemate","","","","",""],
["","you","","yep","ttt_continue_delay","","null","",""],
["ttt_loss1","oliver","_none","i win!","","","","",""],
["","you","","damn","ttt_continue_delay","","null","",""],
["ttt_game2","oliver","_none","up for another?","","","","",""],
["","you","","sure","ttt_init_delay","","null","",""],
["ttt_bad","oliver","_none","i wouldn't have done that, if i were you","","","","",""],
["","you","","uh oh","ttt_continue_delay","","null","",""],
["ttt_very_bad","oliver","_none","um, are you sure about that?","","","","",""],
["","you","","oh","ttt_continue_delay","","null","",""],
["ttt_about_to_lose","you","_none","crap","ttt_continue_delay","","null","",""]
]