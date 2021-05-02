extends "state_handler_template.gd"

const empty_space = '                              '

onready var game = get_node('../../../../..')
var last_editable_text = null
var text_n = -1
var choice_n = 0
var choice_log = {}
var choice_text = {}
var input_text = {}

var text_dependencies = {}
var ending_label = null
	
func _ready():
	for text in $hc/vc.get_children():
		if text is RichTextLabel:
			text.modulate.a = 0
	$next_cover.show()
	$next_button.hide()
	$wake_up_cover.hide()
	format_text()
	
func next():
	# if the previous line of text was a choice, turn off the button so it doesn't cause highlighting
	var old = null
	if text_n >= 0:
		old = $hc/vc.get_child(text_n)
	if old and old.name[0] == 'c':
		var old_choice = old.get_node('choice_container').get_child(choice_n)
		old_choice.get_node('Button').hide()
		
		# also get rid of the underline and store the choice for later
		old_choice.set_bbcode(old_choice.get_bbcode().replace('[u]', '').replace('[/u]', ''))
		choice_log[text_n] = choice_n
		choice_text[text_n] = old_choice.text
	
	# try getting the next line of text
	text_n += 1
	var current = $hc/vc.get_child(text_n)
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
					var_text.set_bbcode(last_editable_text % empty_space)
					$next_cover.hide()
		
		# if it's a lineedit...
		if current.name[0] == 'e':
			last_editable_text = current.get_bbcode()
			current.set_bbcode(last_editable_text % empty_space)
			$next_cover.hide()
			
		# if it's a choice...
		elif current.name[0] == 'c':
			$next_button.hide()
			$next_cover.hide()
			choice_n = 0
			
			# show the default choice
			print(current)
			print(current.get_node('choice_container').get_child(0))
			var default_choice = current.get_node('choice_container').get_child(0).show()
			
	else: 
		$next_button.hide()
		$next_cover.hide()
		
		# if the last line of text was interactable, then let them look at it for a while
		if old and (old.name[0] == 'c' or last_editable_text):
			$next_cover.show()
		
		# otherwise fade out all the text and enable the "wake up" cover
		else:
			$hc/vc/AnimationPlayer.play_backwards('Fadein')
			$wake_up_cover.show()
	
	# also, if the previous line of text had a lineedit, format it correctly
	if old and last_editable_text:
		for child in old.get_children():
			if child.name[0] == 'e' and child.get_node('LineEdit').text != '':
				print(child.name)
				var lineedit = child.get_node('LineEdit')
				lineedit.get_parent().set_bbcode(last_editable_text % lineedit.text)
				lineedit.get_parent().get_node('underline').hide()
				lineedit.hide()
				last_editable_text = null
				input_text[text_n - 1] = lineedit.text

func cycle_choice():
	var text = $hc/vc.get_child(text_n)
	var choice_container = text.get_node('choice_container')
	choice_container.get_child(choice_n).hide()
	
	choice_n += 1
	if choice_n >= choice_container.get_children().size():
		choice_n %= choice_container.get_children().size()
	
	var choice = choice_container.get_child(choice_n)
	choice.get_node('Button').show_custom()
	
	if not $next_button.visible:
		show_next_button()

	# every time you cycle a choice, you have to reposition any text that comes after the choice
	if text.has_node('end_text'):
		var font = text.get_font('normal_font')
		var width = font.get_string_size(text.get_text()).x
		var c_width = font.get_string_size(choice.get_text()).x
		text.get_node('end_text').set_position(Vector2(width + c_width, 0))

# there's a placeholder argument as a hack, because...? reasons?
func show_next_button(what = null):
	if $next_button.visible:
		return
	$next_button.modulate.a = 0
	$next_button.get_node('text').set_bbcode('[center]next[/center]')
	$next_button.show()
	$next_button.get_node('AnimationPlayer').play("Fadein")

func wake_up():
	if ending_label:
		emit_signal('start_dialog', ending_label, [])

func options_changed():
	format_text()

# helper function for text formatting
func max_text_width(font, texts):
	var max_width = 0
	for text in texts:
		if text is RichTextLabel:
			var width = font.get_string_size(text.get_text()).x
			if width > max_width:
				max_width = width
	return max_width
	
func format_text():
	# first, set the width of the vertical container to the length of the longest line.
	# this code might break if you use italics. don't use fucking italics
	
	var max_width = 0
	var font = $hc/vc.get_child(0).get_font('normal_font')
	
	for text in $hc/vc.get_children():
		if not text is RichTextLabel:
			continue
		var width = font.get_string_size(text.get_text()).x
		
		# if it's a choice, add the length of the longest choice
		if text.name[0] == 'c':
			width += max_text_width(font, text.get_node('choice_container').get_children())
			# add the length of the end text, too, if there is any
			if text.has_node('end_text'):
				width += font.get_string_size(text.get_node('end_text').get_text()).x
	
		# if it's a variable text (a text with width 0), use the longest option
		if width == 0:
			width = max_text_width(font, text.get_children())
		
		# we're just ignoring lineedits here, not worth the headache
		if width > max_width:
			max_width = width
			
	$hc/vc.set_custom_minimum_size(Vector2(max_width, 0))
	
	# then, change the height of each text to match the font size
	
	for text in $hc/vc.get_children():
		if not text is RichTextLabel:
			continue
		var text_height = font.get_height() * 1.5
		text.set_custom_minimum_size(Vector2(max_width, text_height))
	
	# finally, snap each choice (and end text) to the correct x position
	# and resize the buttons and lineedits while you're at it
	
	for text in $hc/vc.get_children():
		if text.name[0] == 'c':
			# snapping choices
			var choice_container = text.get_node('choice_container')
			var width = font.get_string_size(text.get_text()).x
			choice_container.set_position(Vector2(width, 0))
			
			# snapping end text
			if text.has_node('end_text'):
				var visible_choice_n = 0
				if text_n > int(text.name[1]):
					visible_choice_n = choice_log[text.name[1]]
				if text_n == int(text.name[1]):
					visible_choice_n = choice_n
					
				var visible_choice = choice_container.get_child(visible_choice_n)
				var visible_choice_width = font.get_string_size(visible_choice.get_text()).x
				text.get_node('end_text').set_position(Vector2(width + visible_choice_width, 0))
			
			# resizing buttons
			for choice in choice_container.get_children():
				var choice_size = font.get_string_size(choice.get_text())
				choice.get_node('Button').set_size(choice_size)
		
		# resizing lineedits
		# note: if there's multiple lineedits in a text, then it's going to break
		var lineedit = text.find_node('LineEdit')
		if lineedit:
			var space_size = font.get_string_size(empty_space)
			lineedit.set_size(space_size)
			
func set_format_dict(key, value):

	var formatter = [
		['your', 'my'], 
		['you', 'i'], 
		['.', '']
	]
	for pair in formatter:
		value = value.replacen(pair[0], pair[1])
		
	game.format_dict['bio.' + key] = value
	
