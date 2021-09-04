extends 'state_handler_template.gd'

func _ready():
	yield(get_tree(), 'idle_frame')
	var game = get_node('../../../../../')
	var audio = game.main_audio
	if audio:
		audio.connect('finished', self, 'audio_finished')

func audio_finished():
	var game = get_node('../../../../../')
	# don't do the easter egg if dialog is happening
	if game.get_node('content/ui').visible:
		return
	# or if you've already seen the easter egg
	if game.state.get('flew_to_the_meow'):
		return
	# or if fly me to the meow isn't playing
	if game.current_audio == 'Fly_Me_To_The_Meow':
		emit_signal('start_dialog', 'flew_to_the_meow', [])
		game.state['flew_to_the_meow'] = true