extends "state_handler_template.gd"

const empty_space = '                              '

onready var game = get_node('../../../../..')
var last_editable_text = []
var text_n = -1
var choice_n = 0
var choice_log = {}
var choice_text = {}
var input_text = {}

var text_dependencies = {}
var ending_label = null

onready var lang_nodes = $text.get_children()
	
func _ready():
	for lang_node in lang_nodes:
		for text in lang_node.get_node('vc').get_children():
			if text is RichTextLabel:
				text.modulate.a = 0
	$next_cover.show()
	$next_button.hide()
	$wake_up_cover.hide()
	format_text()
	
func next():
	# if the previous line of text was a choice, turn off the button so it doesn't cause highlighting, and save the choice
	var olds = []
	if text_n >= 0:
		for lang_node in lang_nodes:
			olds.append(lang_node.get_node('vc').get_child(text_n))

	if olds.size() > 0:
		# we only need to save the number of the choice (in choice_log) and the english text of the choice (in choice_text)
		if olds[0] and olds[0].name[0] == 'c':
			choice_log[text_n] = choice_n
			choice_text[text_n] = olds[0].get_node('choice_container').get_child(choice_n).text
	
		# but we need to fix the button and formatting for all langs
		for old in olds:
			if old and old.name[0] == 'c':
				var old_choice = old.get_node('choice_container').get_child(choice_n)
				old_choice.get_node('Button').hide()
			
				# get rid of the underline and store the choice for later
				old_choice.set_bbcode(old_choice.get_bbcode().replace('[u]', '').replace('[/u]', ''))
				old_choice.set_bbcode(old_choice.get_bbcode().replace('[i]', '').replace('[/i]', ''))
	
	# try getting the next line of text
	text_n += 1
	var currents = []
	for lang_node in lang_nodes:
		currents.append(lang_node.get_node('vc').get_child(text_n))
	# if there is one...
	var all_done = false
	for current in currents:
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
						last_editable_text.append(var_text.get_bbcode())
						var_text.set_bbcode(var_text.get_bbcode() % empty_space)
						$next_cover.hide()
			
			# if it's a lineedit...
			if current.name[0] == 'e':
				last_editable_text.append(current.get_bbcode())
				current.set_bbcode(current.get_bbcode() % empty_space)
				$next_cover.hide()
				
			# if it's a choice...
			elif current.name[0] == 'c':
				$next_button.hide()
				$next_cover.hide()
				choice_n = 0
				
				# show the default choice
				#print(current)
				#print(current.get_node('choice_container').get_child(0))
				var default_choice = current.get_node('choice_container').get_child(0).show()
				
		else: 
			all_done = true # need to do this outside of the for loop so it only happens once
	
	if all_done:
		$next_button.hide()
		$next_cover.hide()
		
		# if the last line of text was interactable, then let them look at it for a while
		if olds.size() > 0 and olds[Language.language] and (olds[Language.language].name[0] == 'c' or last_editable_text.size() > 0):
			$next_cover.show()
		
		# otherwise fade out all the text and enable the "wake up" cover
		else:
			$AnimationPlayer.play_backwards('Fadein')
			$wake_up_cover.show()
		
	# also, if the previous line of text had a lineedit, we need to save the player's input and format it correctly
	if olds.size() > 0 and last_editable_text.size() > 0:
		# use the current language's nodes to see if there was a lineedit, and if so, save what the player entered
		var player_input = null
		for child in olds[Language.language].get_children():
			if child.name[0] == 'e':
				if child.get_node('LineEdit').text != "":
					input_text[text_n - 1] = child.get_node('LineEdit').text
					player_input = child.get_node('LineEdit').text
		
		# now update the text in all languages to reflect the player's input
		if player_input:
			for i in range(olds.size()):
				for child in olds[i].get_children():
					if child.name[0] == 'e':
						var lineedit = child.get_node('LineEdit')
						lineedit.get_parent().set_bbcode(last_editable_text[i] % player_input)
						lineedit.get_parent().get_node('underline').hide()
						lineedit.hide()
			last_editable_text = []

func cycle_choice():
	var size 
	for lang_node in lang_nodes:
		var text = lang_node.get_node('vc').get_child(text_n)
		var choice_container = text.get_node('choice_container')
		size = choice_container.get_children().size()
		choice_container.get_child(choice_n).hide()
		
		var choice = choice_container.get_child((choice_n + 1) % size)
		choice.get_node('Button').show_custom()
		
		if not $next_button.visible:
			show_next_button()
	
		# every time you cycle a choice, you have to reposition any text that comes after the choice
		if text.has_node('end_text'):
			var font = text.get_font('normal_font')
			var width = font.get_string_size(text.get_text()).x
			var c_width = font.get_string_size(choice.get_text()).x
			text.get_node('end_text').set_position(Vector2(width + c_width, 0))
			
	choice_n = (choice_n + 1) % size

# there's a placeholder argument as a hack, because...? reasons?
func show_next_button(what = null):
	if $next_button.visible:
		return
	$next_button.modulate.a = 0
	# idk why this line is necessary but it was manually resetting the text, so i'm just gonna keep it but with multiple languages
	$next_button.get_node('text').update_label(Language.language)
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

func format_text(_lang=null):
	for i in range(lang_nodes.size()):
		var lang_node = lang_nodes[i]
		# first, set the width of the vertical container to the length of the longest line.
		# this code might break if you use italics. don't use fucking italics
		
		var max_width = 0
		var font = lang_node.get_node('vc').get_child(0).get_font('normal_font')
		
		for text in lang_node.get_node('vc').get_children():
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
				
		lang_node.get_node('vc').set_custom_minimum_size(Vector2(max_width, 0))
		
		# then, change the height of each text to match the font size
		
		for text in lang_node.get_node('vc').get_children():
			if not text is RichTextLabel:
				continue
			var text_height = font.get_height() * 1.5
			text.set_custom_minimum_size(Vector2(max_width, text_height))
		
		# finally, snap each choice (and end text) to the correct x position
		# and resize the buttons and lineedits while you're at it
		
		for text in lang_node.get_node('vc').get_children():
			if text.name[0] == 'c':
				# snapping choices
				var choice_container = text.get_node('choice_container')
				var width = font.get_string_size(text.get_text()).x
				choice_container.set_position(Vector2(width, 0))
				
				# snapping end text
				if text.has_node('end_text'):
					var visible_choice_n = 0
					if text_n > int(text.name[1]):
						visible_choice_n = choice_log[int(text.name[1])]
					if text_n == int(text.name[1]):
						visible_choice_n = choice_n
						
					var visible_choice = choice_container.get_child(visible_choice_n)
					var visible_choice_width = font.get_string_size(visible_choice.get_text()).x
					text.get_node('end_text').set_position(Vector2(width + visible_choice_width, 0))
				
				# resizing buttons
				for choice in choice_container.get_children():
					var choice_size = font.get_string_size(choice.get_text())
					choice.get_node('Button').rect_size = choice_size
			
			# this assumes all lineedits are nested two deep
			# which, they are, i think
			# it's a dumb assumption but it works
			for option in text.get_children():
				if option.name[0] == 'e' and option.name.length() == 2:
					# snapping lineedit
					var start_text
					if last_editable_text.size() > 0:
						start_text = last_editable_text[i].split('%s')[0]
					else:
						start_text = option.text.split('%s')[0]
					var start_width = font.get_string_size(start_text).x
					var lineedit = option.get_node('LineEdit')
					var underline = option.get_node('underline')
					lineedit.set_position(Vector2(start_width, 0))
					underline.set_position(Vector2(start_width, 5))
				
					# resizing lineedit
					var space_size = font.get_string_size(empty_space)
					lineedit.set_size(space_size)
					underline.set_size(space_size)
					
					# snapping end text
					#if option.has_node('end_text'):
						#option.get_node('end_text').set_position(Vector2(option_width + space_size.x, 0))
			
func set_format_dict(key, value, lang=0):
	if lang == 0: # english
		var formatter = [
			['your', 'my'], 
			['you', 'i'], 
			['.', '']
		]
		for pair in formatter:
			value = value.replacen(pair[0], pair[1])
		
		# the formatter fucks up "young adult novel" lmao
		value = value.replacen("ing adult", "young adult")
			
		game.format_dict['bio.' + key] = value
	
	else:
		game.format_dict['bio.' + key] = value
		
