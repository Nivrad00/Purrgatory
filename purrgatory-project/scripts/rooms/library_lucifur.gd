extends 'state_handler_template.gd'
	
onready var game = get_node('../../../../..')

var choice_dict = {
	'gluttony': [['my favorite food', 'lucifur_bio_gluttony'], ['mi comida favorita', 'lucifur_bio_gluttony']],
	'pride': [['something about myself', 'lucifur_bio_pride'], ['algo sobre mí', 'lucifur_bio_pride']],
	'wrath': [['where i grew up', 'lucifur_bio_wrath'], ['el lugar donde me crié', 'lucifur_bio_wrath']],
	'envy': [['someone i admired', 'lucifur_bio_envy'], ['alguien a quien admiraba', 'lucifur_bio_envy']],
	'lust': [['someone important', 'lucifur_bio_lust'], ['alguien importante', 'lucifur_bio_lust']],
	'greed': [['my greatest desire', 'lucifur_bio_greed'], ['mi mayor anhelo', 'lucifur_bio_greed']],
	'sloth': [['what i always wanted to do', 'lucifur_bio_sloth'], ['lo que siempre quise hacer', 'lucifur_bio_sloth']],
	'something_else0': [['(something else...)', 'lucifur_bio0'], ['(otra cosa...)', 'lucifur_bio0']],
	'something_else1': [['(something else...)', 'lucifur_bio1'], ['(otra cosa...)', 'lucifur_bio1']],
	'something_else2': [['(something else...)', 'lucifur_bio2'], ['(otra cosa...)', 'lucifur_bio2']],
	'done': [['...', 'lucifur_bio_done'], ['...', 'lucifur_bio_done']]
}
	
func init_state(state):
	.init_state(state)
	var bio_choices = []
	
	if state.get('kyungsoon_quest_complete'):
		bio_choices.append(choice_dict['gluttony'])
	if state.get('oliver_quest_complete'):
		bio_choices.append(choice_dict['pride'])
	if state.get('numa_quest_complete'):
		bio_choices.append(choice_dict['wrath'])
	if state.get('elijah_quest_complete'):
		bio_choices.append(choice_dict['envy'])
	if state.get('sean_quest_complete'):
		bio_choices.append(choice_dict['lust'])
	if state.get('tori_quest_complete'):
		bio_choices.append(choice_dict['greed'])
	if state.get('natalie_quest_complete'):
		bio_choices.append(choice_dict['sloth'])
		
	state['bio_choices'] = bio_choices
		
func update_state(state):
	.update_state(state)
	
	if state.get('gave_cat_toy'):
		$cat_toy.show()
	else:
		$cat_toy.hide()

	if state.get('show_bio_choices0') or state.get('show_bio_choices1') or state.get('show_bio_choices2'):
		var choices = []
		
		if state.get('show_bio_choices0'):
			state['show_bio_choices0'] = false
		
			if state['bio_choices'].size() > 4:
				choices = [
					state['bio_choices'][0][Language.language],
					state['bio_choices'][1][Language.language],
					state['bio_choices'][2][Language.language],
					choice_dict['something_else1'][Language.language]
				]
			elif state['bio_choices'].size() > 0:
				choices = []
				for choice in state['bio_choices']:
					choices.append(choice[Language.language])
			else:
				choices = [
					choice_dict['done'][Language.language]
				]
				
		elif state.get('show_bio_choices1'):
			state['show_bio_choices1'] = false
		
			if state['bio_choices'].size() == 7:
				choices = [
					state['bio_choices'][3][Language.language],
					state['bio_choices'][4][Language.language],
					state['bio_choices'][5][Language.language],
					choice_dict['something_else2'][Language.language]
				]
			elif state['bio_choices'].size() == 6:
				choices = [
					state['bio_choices'][3][Language.language],
					state['bio_choices'][4][Language.language],
					state['bio_choices'][5][Language.language],
					choice_dict['something_else0'][Language.language]
				]
			elif state['bio_choices'].size() == 5:
				choices = [
					state['bio_choices'][3][Language.language],
					state['bio_choices'][4][Language.language],
					choice_dict['something_else0'][Language.language]
				]
				
		elif state.get('show_bio_choices2'):
			state['show_bio_choices2'] = false
		
			choices = [
				state['bio_choices'][6][Language.language],
				choice_dict['something_else0'][Language.language]
			]
		
		var choices_text = []
		for choice in choices:
			choices_text.append(choice[0])
			
		game.block['choices'] = choices
		# tts set to false for this one, since the original update_ui call already
		# triggers the tts
		game.ui.update_ui(null, null, null, choices_text, false)
		
	if state.get('lucifur_talked_about_gluttony'):
		state['lucifur_talked_about_gluttony'] = false
		state['bio_choices'].erase(choice_dict['gluttony'])
	if state.get('lucifur_talked_about_pride'):
		state['lucifur_talked_about_pride'] = false
		state['bio_choices'].erase(choice_dict['pride'])
	if state.get('lucifur_talked_about_wrath'):
		state['lucifur_talked_about_wrath'] = false
		state['bio_choices'].erase(choice_dict['wrath'])
	if state.get('lucifur_talked_about_envy'):
		state['lucifur_talked_about_envy'] = false
		state['bio_choices'].erase(choice_dict['envy'])
	if state.get('lucifur_talked_about_lust'):
		state['lucifur_talked_about_lust'] = false
		state['bio_choices'].erase(choice_dict['lust'])
	if state.get('lucifur_talked_about_greed'):
		state['lucifur_talked_about_greed'] = false
		state['bio_choices'].erase(choice_dict['greed'])
	if state.get('lucifur_talked_about_sloth'):
		state['lucifur_talked_about_sloth'] = false
		state['bio_choices'].erase(choice_dict['sloth'])
		
