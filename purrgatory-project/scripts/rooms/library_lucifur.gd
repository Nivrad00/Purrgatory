extends 'state_handler_template.gd'
	
onready var game = get_node('../../../../..')

var choice_dict = {
	'gluttony': ['my favorite food', 'lucifur_bio_gluttony'],
	'pride': ['something about myself', 'lucifur_bio_pride'],
	'wrath': ['where i grew up', 'lucifur_bio_wrath'],
	'envy': ['someone i admired', 'lucifur_bio_envy'],
	'lust': ['someone important', 'lucifur_bio_lust'],
	'greed': ['my greatest setback', 'lucifur_bio_greed'],
	'sloth': ['what i always wanted to do', 'lucifur_bio_sloth'],
	'something_else0': ['(something else...)', 'lucifur_bio0'],
	'something_else1': ['(something else...)', 'lucifur_bio1'],
	'something_else2': ['(something else...)', 'lucifur_bio2'],
	'done': ['...', 'lucifur_bio_done']
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
	
	if state.get('show_bio_choices0') or state.get('show_bio_choices1') or state.get('show_bio_choices2'):
		var choices = []
		
		if state.get('show_bio_choices0'):
			state['show_bio_choices0'] = false
		
			if state['bio_choices'].size() > 4:
				choices = [
					state['bio_choices'][0],
					state['bio_choices'][1],
					state['bio_choices'][2],
					choice_dict['something_else1']
				]
			elif state['bio_choices'].size() > 0:
				choices = state['bio_choices']
			else:
				choices = [choice_dict['done']]
				
		elif state.get('show_bio_choices1'):
			state['show_bio_choices1'] = false
		
			choices = [
				state['bio_choices'][3],
				state['bio_choices'][4],
				state['bio_choices'][5]
			]
				
			if state['bio_choices'].size() > 6:
				choices.append(choice_dict['something_else2'])
			else:
				choices.append(choice_dict['something_else0'])
				
		elif state.get('show_bio_choices2'):
			state['show_bio_choices2'] = false
		
			choices = [
				state['bio_choices'][6],
				choice_dict['something_else0']
			]
		
		var choices_text = []
		for choice in choices:
			choices_text.append(choice[0])
			
		game.block['choices'] = choices
		game.ui.update_ui(null, null, null, choices_text)
		
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
		