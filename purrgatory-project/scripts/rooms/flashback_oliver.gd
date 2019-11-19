extends "state_handler_template.gd"

var last_editable_text = null
var text_n = -1
var choice_n = 0
var choice_log = {}
var text_dependencies = {
	4: 3
}

func _ready():
	for text in $text_container.get_children():
		if text is RichTextLabel:
			text.modulate.a = 0
	$next_cover.show()
	$next_button.hide()
	$wake_up_cover.hide()

func update_state(state):
	.update_state(state)
	if state.get('flashback_goto_commons'):
		emit_signal('change_room', 'commons1')
	
func next():
	# if the previous line of text was a choice, turn off the button so it doesn't cause highlighting
	var old = $text_container.get_child(text_n)
	if old and old.name[0] == 'c':
		var old_choice = old.get_node('choice_container').get_child(choice_n)
		old_choice.get_node('Button').hide()
		
		# also get rid of the underline and store the choice for later
		old_choice.set_bbcode(old_choice.get_bbcode().lstrip('[u]').rstrip('[/u].') + '.')
		choice_log[text_n] = choice_n
	
	# try getting the next line of text
	text_n += 1
	var current = $text_container.get_child(text_n)
	# if there is one...
	if current is RichTextLabel:
		# fade in the new text
		current.get_node('AnimationPlayer').play("Fadein")
		
		# if it's a regular text...
		if current.name[0] == 't':
			$next_cover.show()
			$next_button.hide()
			
			# if it's a variable text, show the correct line based on a previous choice
			if text_dependencies.has(text_n):
				var var_text = current.get_child(choice_log[text_dependencies[text_n]] + 1)
				var_text.show()
				
				# check if there's a lineedit WITHIN the variable text
				if var_text.name[0] == 'e':
					last_editable_text = var_text.get_bbcode()
					var_text.set_bbcode(last_editable_text % '                              ')
					$next_cover.hide()
		
		# if it's a lineedit...
		if current.name[0] == 'e':
			last_editable_text = current.get_bbcode()
			current.set_bbcode(last_editable_text % '                              ')
			$next_cover.hide()
			
		# if it's a choice...
		elif current.name[0] == 'c':
			$next_cover.hide()
			choice_n = 0
			
			# show the default choice
			var default_choice = current.get_node('choice_container').get_child(0).show()
			
	else: 
		$next_button.hide()
		$next_cover.hide()
		
		# if the last line of text was interactable, then let them look at it for a while
		if old and (old.name[0] == 'c' or last_editable_text):
			$next_cover.show()
		
		# otherwise fade out all the text and enable the "wake up" cover
		else:
			$text_container/AnimationPlayer.play_backwards('Fadein')
			$wake_up_cover.show()
	
	# also, if the previous line of text had a lineedit, format it correctly
	if old and old.find_node('LineEdit') and last_editable_text:
		var lineedit = old.find_node('LineEdit')
		lineedit.get_parent().set_bbcode(last_editable_text % lineedit.text)
		lineedit.get_parent().get_node('underline').hide()
		lineedit.hide()
		last_editable_text = null

func cycle_choice():
	var choice_container = $text_container.get_child(text_n).get_node('choice_container')
	choice_container.get_child(choice_n).hide()
	
	choice_n += 1
	if choice_n >= choice_container.get_children().size():
		choice_n %= choice_container.get_children().size()
		
	choice_container.get_child(choice_n).get_node('Button').show_custom()
	
	if not $next_button.visible:
		show_next_button()

# there's a placeholder argument as a hack, because...? reasons?
func show_next_button(what = null):
	print('boop')
	if $next_button.visible:
		return
	$next_button.modulate.a = 0
	$next_button.get_node('text').set_bbcode('[center]next[/center]')
	$next_button.show()
	$next_button.get_node('AnimationPlayer').play("Fadein")

func wake_up():
	emit_signal('start_dialog', 'oliver_end_pride_flashback', [])
