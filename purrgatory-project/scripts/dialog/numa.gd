extends Node

var raw_blocks = [
["talk_to_numa","_none","_none","_pass","","not met_numa",['numa_intro1', 'numa_c'],"",""],
["numa_c","","","_pass","","trample_flag",['numa_intro2', 'numa_default'],"",""],
["numa_intro1","_none","numa_neutral","you approach the woman watering a very foul-smelling flower","met_numa","","","",""],
["","you","","hey","trample_flag","","","",""],
["","???","","oh, hello","","","","",""],
["","you","","gardening, huh?","","","","",""],
["","_none","","she nods","","","","",""],
["","you","","i'm {player}. what's your name?","","","","",""],
["","???","","numa.","","","","",""],
["","","","","","","","",[['it\'s cool that purrgatory has a garden', 'numa_garden'], ['i can\'t believe plants can grow here', 'numa_grow'], ['your flowers smell kind of bad', 'numa_smell']]],
["numa_garden","you","","it's cool that purrgatory has a garden","","","numa_blank1","",""],
["numa_grow","you","","i can't believe plants can grow here","","","numa_blank1","",""],
["numa_smell","you","","your flowers smell kind of bad…","","","numa_blank1","",""],
["numa_blank1","numa","","…","","","","",""],
["","","","","","","","",[['what are you going to do with these flowers?', 'numa_do_what'], ['what kind of flower is that?', 'numa_what_kind'], ['what\'s your favorite kind of flower?', 'numa_favorite']]],
["numa_do_what","you","","what are you planning on doing with those flowers?","","","numa_blank2","",""],
["numa_what_kind","you","","what kind of flower are you watering?","","","numa_blank2","",""],
["numa_favorite","you","","what's your favorite kind of flower?","","","numa_blank2","",""],
["numa_blank2","_none","","numa shrugs.","","","","",""],
["","you","","uhh","","","","",""],
["","","","","","","","",[['you don\'t talk much', 'numa_talk_much'], ['bye for now', 'numa_bye']]],
["numa_talk_much","you","","you don't talk much, do you?","","","","",""],
["","_none","","numa shakes her head.","","","","",""],
["numa_bye","you","","bye for now, i guess","","","","",""],
["","","","enjoy gardening!","","","","",""],
["","_none","","numa nods","","","null","",""],
["numa_intro2","_none","","maybe you should give her some space for now.","","","null","",""],
["numa_leave","numa","numa_neutral","HEY! watch your step!","nearly_trampled_flower","","","",""],
["","_none","","you freeze just before you step on some sprouts","","","","",""],
["","numa","","i mean, please watch your step, if you don't mind","","","","",""],
["","","","sorry","","","","",""],
["","","","i didn't mean to yell","","","","",""],
["","you","","um, it's okay","","","","",""],
["","","","i'll try not to step on anything","","","","",""],
["","numa","","it's okay, just, stay on the path please","","","","",""],
["","","","sorry","","","","",""],
["","you","","it's ok","","","","",""],
["","numa","","…","","","null","",""],
["numa_default","_none","_none","_pass","","numa_quest_complete",['ks_and_numa', 'numa_default2'],"",""],
["numa_default2","_none","numa_neutral","the rancid smell of the flowers assaults you once more.","","","","",""],
["numa_default_c1","","","_pass","","numa_pissed_off and not numa_snooped",['numa_default_taciturn', 'numa_default_main'],"",""],
["numa_default_taciturn","","","","","","",['true', 'true', 'not numa_asked_about_eyes', 'not numa_asked_about_others'],[['what\'s up?', 'numa_dot'], ['how are the flowers?', 'numa_dot'], ['do you technically have four eyes?', 'numa_dot'], ['have you met the others?', 'numa_dot']]],
["numa_default_main","","","","","","",['true', 'true', 'not numa_asked_about_eyes', 'not numa_asked_about_others and not numa_snooped', 'numa_snooped'],[['what\'s up?', 'numa_wasup'], ['how are the flowers?', 'numa_how'], ['do you technically have four eyes?', 'numa_eyes'], ['have you met the others?', 'numa_others'], ['so, about kyungsoon…', 'numa_ks']]],
["numa_others","you","","have you met oliver and kyungsoon?","numa_asked_about_others","","","",""],
["","_none","","numa nods","","","","",""],
["","you","","you must get to know each other pretty well when you're stuck in purrgatory together.","","","","",""],
["","numa","","well, um","","","","",""],
["","","","kyungsoon…","","","","",""],
["","","","…","","","","",""],
["","you","","yes?","","","","",""],
["","numa","","…","","","","",""],
["","you","","what about kyungsoon?","","","","",""],
["","numa","","•••","","","","",""],
["","you","","did she... do something bad?","","","","",""],
["","numa","","no no no no","","","","",""],
["","","","never mind ;;","","","","",""],
["","you","","uh, alright","","","null","",""],
["numa_wasup","you","","what's up?","","","","",""],
["","numa","","not much","","","","",""],
["","you","","cool","","","null","",""],
["numa_how","you","","how are the flowers?","","","","",""],
["","numa","","good","","","","",""],
["","you","","good to hear","","","","",""],
["","numa","","…","","","","",""],
["","","","","","","",['true', 'not numa_asked_about_gardener', 'not numa_asked_about_time and not numa_snooped', 'true'],[['you seem to care about them a lot', 'numa_protective'], ['were you a gardener in real life?', 'numa_gardener'], ['do you spend all your time here?', 'numa_time'], ['(end the conversation)', 'numa_end']]],
["numa_time","you","","do you spend all your time gardening?","numa_asked_about_time","","","",""],
["","numa","","not really, sometimes i stay in my room","","","","",""],
["","you","","wait, you have a room?","","","","",""],
["","","","where?","","","","",""],
["","numa","","um","","","","",""],
["","","","it's in the vents","","","","",""],
["","you","","huh","","","null","",""],
["numa_protective","you","","you seem to care about those flowers a lot","","","","",""],
["","numa","","…sorry…","","","","",""],
["","","","","","","","",[['do people step on them a lot?', 'numa_step'], ['you should relax', 'numa_loose'], ['(pretend to step on a flower)', 'numa_pretend']]],
["numa_step","you","","do people step on them a lot?","","","","",""],
["","numa","","not really","","","","",""],
["","you","","oh","","","","",""],
["","","","well, i guess you nipped that problem in the [i]bud[/i]","","","","",""],
["","numa","","…","","","","",""],
["","","","heh","","","","",""],
["","you","","hehe","","","null","",""],
["numa_loose","you","","you seem kind of stressed. maybe you should relax a little.","","","","",""],
["","numa","","gardening is relaxing.","","","","",""],
["","you","","ah, i see","","","","",""],
["","numa","","…","","","null","",""],
["numa_pretend","you","","what if i did this?","numa_pissed_off","","","",""],
["","_none","","you lift your foot in preparation to squash a flower","","","","",""],
["","numa","","…","","","","",""],
["","you","","i'm gonna step on it","","","","",""],
["","numa","","•••","","","","",""],
["","you","","really? nothing?","","","","",""],
["","_none","","numa looks like she's going to cry","","","","",""],
["","you","","never mind.","","","null","",""],
["numa_dot","numa","","…","","","","",""],
["","_none","","it looks like she doesn't want to talk to you anymore.","","","null","",""],
["numa_eyes","you","","those are your eyestalks, right?","numa_asked_about_eyes","","","",""],
["","numa","","mhm","","","","",""],
["","you","","does that mean you technically have four eyes?","","","","",""],
["","numa","","yeah…","","","","",""],
["","you","","dope","","","null","",""],
["numa_gardener","you","","were you a gardener in real life, too?","numa_asked_about_gardener","","","",""],
["","numa","","no, i was an intern at an accounting firm","","","","",""],
["","you","","oh, i see","","","","",""],
["","","","did you like it?","","","","",""],
["","numa","","mhm","","","","",""],
["","","","","","","","",[['sounds kinda boring', 'numa_boring'], ['sounds like my kind of job',  'numa_job'], ['cool', 'numa_cool']]],
["numa_cool","you","","that's pretty cool","","","","",""],
["","numa","","…","","","null","",""],
["numa_boring","you","","isn't accounting boring? what kind of stuff did you do, anyway?","","","","",""],
["","numa","","…","","","","",""],
["","","","financial statements and stuff","","","","",""],
["","you","","does that mean you could do my taxes?","","","","",""],
["","numa","","no","","","","",""],
["","","","that's the wrong type of accountant","","","","",""],
["","you","","oh, my bad","","","null","",""],
["numa_job","you","","i think i would have liked being an accountant. ","","","","",""],
["","","","i always liked numbers","","","","",""],
["","numa","","i liked making spreadsheets","","","","",""],
["","you","","i love spreadsheets!","","","","",""],
["","numa","",":)","","","","",""],
["","you","","what kind of accounting did you do?","","","","",""],
["","numa","","i wanted to be a CPA","","","","",""],
["","","","i did financial accounting mostly","","","","",""],
["","","","cash flow and balance sheets and stuff like that","","","","",""],
["","you","","ah, i see","","","","",""],
["","numa","","sorry, it's kind of boring","","","","",""],
["","you","","no, no, not at all.","","","","",""],
["","numa","","…","","","null","",""],
["numa_end","you","","well, seeya later","","","","",""],
["","numa","","seeya","","","null","",""],
["snoop","_none","numa_neutral","you stop short as you run into numa in the vents.","met_numa","","","",""],
["","you","","numa?","","","","",""],
["","numa","","…","","","","",""],
["","you","","um, is this where you live?","","","","",""],
["","_none","","numa nods","","","","",""],
["","","","","","","","",[['i\'m sorry', 'snoop_sorry'], ['…', 'snoop_dots']]],
["snoop_sorry","you","","i'm sorry, i was just exploring and i didn't know","","","","",""],
["","numa","","it's... ok","","","snoop_1","",""],
["snoop_dots","you","","…","","","","",""],
["snoop_1","numa","","um","","","","",""],
["","","","did you read my notebook","","","","",""],
["","","","","","","","",[['yes', 'snoop_yes'], ['no', 'snoop_no']]],
["snoop_yes","you","","yes, i'm sorry","","","","",""],
["","","","i was just curious","","","","",""],
["","numa","","oh…","","","","",""],
["","_none","","numa looks distraught","","","","",""],
["","you","","it's okay! it wasn't embarrassing or anything!","","","","",""],
["","numa","","…","","","","",""],
["","you","","i just took a peek, really","","","","",""],
["","numa","","…","","","snoop_2","",""],
["snoop_no","you","","no, of course not","","","","",""],
["","numa","","oh, good","","","","",""],
["snoop_2","","","","","","",['not snoop_keeping_track', 'true', 'true'],[['are you counting the days you\'ve been here?', 'snoop_track'], ['is that a drawing of you and kyungsoon?', 'snoop_pic'], ['could you back up please', 'snoop_back']]],
["snoop_track","you","","are you keeping track of how long you've been here?","snoop_keeping_track","","","",""],
["","numa","","um, yeah…","","","","",""],
["","you","","how come?","","","","",""],
["","numa","","i don't know, i just have to keep track","","","","",""],
["","","","otherwise i feel like i'll never get out of here…","","","","",""],
["","you","","i see","","","snoop_2","",""],
["snoop_pic","you","","is that a drawing of you and kyungsoon?","","","","",""],
["","numa","","um, yes","","","","",""],
["snoop_friends","you","","you two must be friends, then","","","","",""],
["","numa","","not really…","","","","",""],
["","you","","um… girlfriends?","","","","",""],
["","_none","","numa squeaks something that you can't hear","","","","",""],
["snoop_pre_crush","","","","","","",['true', 'not snoop_tried_to_leave'],[['you have a crush on her?', 'snoop_crush'], ['could you back up please', 'snoop_back2']]],
["snoop_crush","you","","do you… have a crush on her?","","","","",""],
["","_none","","numa takes a deep breath.","","","","",""],
["","numa","","YES I HAVE A CRUSH ON KYUNGSOON!!","","","","",""],
["","you","","oh","","","","",""],
["","numa","","and i've been stuck here for years but i can never work up the courage to talk to her","","","","",""],
["","","","and i've never told anyone this either because i'm sure she would hate me","","","","",""],
["","","","and i want to give her flowers but they all smell horrible","","","","",""],
["","","","and","","","","",""],
["","","","i'm sorry i didn't mean to say all that ;;","","","","",""],
["","you","","no, it's ok","","","","",""],
["","numa","","i'm sorry, i should just go","","","","",""],
["","you","","it's ok, it's ok! it's just…","","","","",""],
["snoop_c","","","","","","",['not snoop_fluffy', 'not snoop_offered_to_talk', 'true'],[['i don\'t see what\'s so attractive about her', 'snoop_attractive'], ['would you like me to talk to her for you?', 'snoop_talk'], ['could you pleeease back up', 'snoop_back3']]],
["snoop_back","you","","could you, uh, back up please? there's not enough space to crawl past you","","","","",""],
["","numa","","um, okay","","","","",""],
["","","","i was just wondering if you… saw the picture","","","","",""],
["","you","","uh, the one of you and kyungsoon?","","","","",""],
["","numa","","oh","","","","",""],
["","","","so you did see it","","","snoop_friends","",""],
["snoop_back2","you","","if you wouldn't mind backing up so i can get out of the vent…","snoop_tried_to_leave","","","",""],
["","numa","","oh, of course, it's just…","","","","",""],
["","","","about kyungsoon…","","","","",""],
["","you","","mhm?","","","","",""],
["","numa","","…","","","snoop_pre_crush","",""],
["snoop_attractive","you","","i don't see what's so attractive about kyungsoon…?","snoop_fluffy","","","",""],
["","numa","","what do you mean? she's so tall and cute and mysterious","","","","",""],
["","","","it's like nothing ever rattles her","","","","",""],
["","","","and she's really smart and witty too…","","","","",""],
["","","","and... fluffy…","","","","",""],
["","you","","huh","","","snoop_c","",""],
["snoop_talk","you","","would you like me to talk to her for you?","snoop_offered_to_talk","","","",""],
["","numa","","NO!!","","","","",""],
["","","","sorry, sorry, i didn't mean to yell","","","","",""],
["","","","but please don't do that","","","","",""],
["","you","","jeez, okay","","","","",""],
["","numa","","if i'm going to tell her, i want it to be perfect","","","","",""],
["","","","i want to give her flowers, a poem, food…","","","","",""],
["","you","","food?","","","","",""],
["","numa","","she really likes food","","","","",""],
["","you","","that's true","","","snoop_c","",""],
["snoop_back3","you","","could you pleeease back up so we can get out of this vent","","","","",""],
["","numa","","oh, sorry","","","","",""],
["","","","sorry, sorry, sorry…","","","","",""],
["","_none","","numa backs up and you finally leave the vent","snoop_leave_vent","","","",""],
["","numa","","…","","","","",""],
["","you","","…","","","","",""],
["","numa","","please don't tell anyone about this.","","","","",""],
["","you","","my lips are sealed.","","","","",""],
["","numa","","can i have the screwdriver please","","","","",""],
["","you","","here","","","","",""],
["","_none","","numa takes the screwdriver and hurries down the stairs.","","","null","",""],
["numa_ks","you","numa_neutral","so, about kyungsoon…","","numa_helping",['numa_gift_options', 'numa_plan'],"",""],
["","numa","","oh","","","","",""],
["","","","sorry about venting to you earlier ;;","","","","",""],
["","you","","heh, no pun intended?","","","","",""],
["","numa","","...what pun?","","","","",""],
["","you","","uh, never mind","","","","",""],
["numa_plan","","","you still want to talk to her, right? what's the plan?","","","","",""],
["","numa","","well, i can't just go up to her and talk to her…","","","","",""],
["","","","i need everything to be perfect.","","","","",""],
["","","","i want to arrange a perfect boquet of flowers","","","","",""],
["","","","and i want to write her a poem","","","","",""],
["","","","and i want to get some food as a gift…","","","","",""],
["","","","sorry, i know that's stupid","","","","",""],
["","","","","","","","",[['i could help you with that', 'numa_help'], ['you should really just talk to her', 'numa_talk']]],
["numa_help","you","","i could try to help you with that","numa_helping","","","",""],
["","numa","","really?","","","","",""],
["","you","","yeah, i'll do my best!","","","","",""],
["","numa","","oh, thank you so much!","","","","",""],
["","","","i think i'm going to need all the help i can get…","","","numa_gift_options","",""],
["numa_talk","you","","it would be a lot easier if you just talked to her","","","","",""],
["","numa","","oh, i can't do that","","","","",""],
["","","","that's way, way, way too scary","","","","",""],
["","you","","we're already dead, what is there to be afraid of?","","","","",""],
["","numa","","i don't know","","","","",""],
["","","","an eternity of self-hatred","","","","",""],
["","","","fueled by inescapable rejection and humiliation?","","","","",""],
["","you","","oh","","","","",""],
["","","","hm","","","","",""],
["","numa","","you see?","","","","",""],
["","you","","it sounds like it's very scary to be you","","","","",""],
["","numa","","it is","","","null","",""],
["numa_gift_options","","","","","","","",[['ready to talk to her?', 'numa_ready?'], ['flowers', 'numa_flowers_c'], ['poem', 'numa_poem_c'], ['food', 'numa_food_c']]],
["numa_flowers_c","","","_pass","","not numa_started_flowers",['numa_flowers1', 'numa_flowers_c2'],"",""],
["numa_flowers_c2","","","_pass","","not numa_finished_flowers",['numa_flowers2', 'numa_flowers3'],"",""],
["numa_flowers1","you","","do you need any help picking out flowers?","numa_started_flowers","","","",""],
["","numa","","yes, please","","","","",""],
["","","","my eyesight is bad, so i have a hard time finding the ones i want ;;","","","","",""],
["","you","","well, how about this one --","","","","",""],
["","numa","","DON'T TOUCH THEM!","","","","",""],
["","","","i mean","","","","",""],
["","","","please don't touch them, i don't want any of them to be damaged","","","","",""],
["","","","just point at them","","","","",""],
["","","","sorry","","","","",""],
["","you","","you're going to give me a heart attack one of these days, numa","","","","",""],
["","numa","","sorryyy ;;","","","flowers_init","",""],
["numa_flowers2","you","","let's give flower-picking another shot…","","","flowers_init","",""],
["numa_flowers3","numa","","thanks again for helping me pick out flowers for kyungsoon","","","","",""],
["","you","","no problem","","","","",""],
["","numa","","i just know she's going to love them :)","","","","",""],
["","","","want to help me find some more, just in case?","","","","",""],
["","","","","","","","",[['sure', 'flowers_init'], ['not right now', 'numa_flowers_not']]],
["numa_flowers_not","you","","not right now, sorry","","","","",""],
["","numa","","oh, okay","","","null","",""],
["numa_poem_c","","","_pass","","not numa_started_poem",['numa_poem1', 'numa_poem_c2'],"",""],
["numa_poem_c2","","","_pass","","not numa_finished_poem",['numa_poem2', 'numa_poem3'],"",""],
["numa_poem1","you","","how's that poem going?","numa_started_poem","","","",""],
["","numa","","i think i need some help…","","","","",""],
["","","","i was always better at math than english","","","","",""],
["","you","","well, let's hear what you have so far.","","","","",""],
["","numa","","are you sure?","","","","",""],
["","","","it's not very good","","","","",""],
["","","","actually, it's awful","","","","",""],
["","you","","how bad can it be?","","","","",""],
["","numa","","…really bad…","","","","",""],
["","you","","come on, just give it a chance","","","","",""],
["","numa","","well, ok…","","","","",""],
["","","","ahem","","","","",""],
["","","","roses are white","","","","",""],
["","","","violets are white","","","","",""],
["","","","to me, you are","","","","",""],
["","","","a shining light","","","","",""],
["","you","","sounds good so far","","","","",""],
["","numa","","you are purple","","","","",""],
["","","","i am orange","","","","",""],
["","","","…","","","","",""],
["","","","sorry, that's all i have","","","","",""],
["","","","nothing rhymes with orange ;;","","","","",""],
["","","","","","","","",[['and your face / i adore-enge', 'numa_adore-enge'], ['you pierce my heart / like a syringe', 'numa_syringe'], ['just switch the last two lines', 'numa_switch']]],
["numa_adore-enge","you","","how about this","","","","",""],
["","","","\"and your face, i adore-enge\"","","","numa_orange_after","",""],
["numa_syringe","you","","how about this","","","","",""],
["","","","\"you pierce my heart, like a syringe\"","","","numa_orange_after","",""],
["numa_switch","you","","just switch the last two lines","","","","",""],
["","","","\"i am orange, you are purple\"","","","","",""],
["","numa","","but what rhymes with purple?","","","","",""],
["","you","","uh","","","","",""],
["","","","","","","","",[['orange soda / i like to slurp-le', 'numa_slurp-le'], ['i got nothing', 'numa_nothing']]],
["numa_slurp-le","you","","\"orange soda, i like to slurp-le\"","","","numa_orange_after","",""],
["numa_nothing","you","","i got nothing","","","numa_suit","",""],
["numa_orange_after","numa","","…","","","","",""],
["","you","","…","","","","",""],
["","","","yeah, that sucks","","","","",""],
["","numa","","sort of, yeah","","","","",""],
["","","","sorry ;;","","","","",""],
["numa_suit","you","","i don't think poetry is my strong suit","","","","",""],
["","numa","","*sigh*","","","","",""],
["","","","i don't think i'm ever going to finish this poem.","","","","",""],
["","you","","don't give up yet, maybe you'll think of something!","","","","",""],
["","numa","","maybe.","","","null","",""],
["numa_poem2","you","","any progress on the poem?","","","","",""],
["","numa","","not yet, sorry","","","","",""],
["","","","i'm so bad at this ;;","","","","",""],
["","you","","take your time","","","","",""],
["","","","we have an eternity after all","","","","",""],
["","numa","","it'll probably take an eternity to finish this…","","","null","",""],
["numa_poem3","you","","was talking to elijah helpful?","","","","",""],
["","numa","","absolutely!","","","","",""],
["","","","i'm just putting some final touches on it now.","","","","",""],
["","you","","can i hear it?","","","","",""],
["","numa","","sure, here's a little excerpt:","","","","",""],
["","","","you are purple","","","","",""],
["","","","i am smitten","","","","",""],
["","","","you're as cute","","","","",""],
["","","","as a kitten","","","","",""],
["","you","","nice!","","","","",""],
["","numa","","i know, it's so cute!","","","null","",""],
["numa_food_c","","","_pass","","not numa_started_food",['numa_food1', 'numa_food_c2'],"",""],
["numa_food_c2","","","_pass","","not numa_progressed_food",['numa_food2', 'numa_food_c3'],"",""],
["numa_food_c3","","","_pass","","not numa_finished_food",['numa_food3', 'numa_food4'],"",""],
["numa_food1","you","","what are you doing about food?","numa_started_food","","","",""],
["","numa","","um, i haven't really thought about it","","","","",""],
["","","","i don't even know what kind of food she likes…","","","","",""],
["","","","","","","","",[['books', 'numa_books'], ['keys', 'numa_keys'], ['signs', 'numa_signs']]],
["numa_books","you","","i heard she likes to eat books.","","","","",""],
["","numa","","books? really?","","","","",""],
["","","","i guess i could give her my notebook…","","","","",""],
["","you","","the one where you write about how much you're in love with her?","","","numa_bad","",""],
["numa_keys","you","","i heard she likes to eat keys.","","","","",""],
["","numa","","keys? really?","","","","",""],
["","","","well, i guess i could give her my screwdriver, which is kind of like a key…","","","","",""],
["","you","","the one you need to get into your room?","","","numa_bad","",""],
["numa_signs","you","","i heard she likes to eat signs.","","","","",""],
["","numa","","signs? really?","","","","",""],
["","","","i guess i could get that meowseum sign for her to eat...","","","","",""],
["","you","","the one that's made of glass?","","","numa_bad","",""],
["numa_bad","numa","","oh","","","","",""],
["","","","you're right, sorry, bad idea","","","","",""],
["","","","i'm so stupid","","","","",""],
["","you","","no you're not!","","","","",""],
["","numa","",";;","","","","",""],
["","you","","maybe i can talk to kyungsoon and find out what she likes","","","","",""],
["","numa","","oh, would you? that would be amazing","","","","",""],
["","you","","i'll see what i can do.","","","null","",""],
["numa_food2","you","","why don't you just give her some of that fruit in the other room?","","","","",""],
["","","","it looks pretty tasty","","","","",""],
["","numa","","oh, those are deathberries","","","","",""],
["","","","don't eat that","","","","",""],
["","","","you'll be sick for weeks","","","","",""],
["","you","","oh","","","","",""],
["","numa","","yep","","","null","",""],
["numa_food3","you","","i asked kyungsoon about her favorite food!","","","","",""],
["","numa","","oh, really?? what did she say?","","","","",""],
["","you","","leaves.","","","","",""],
["","numa","","really? no way!","","","","",""],
["","","","i like eating leaves too!","","","","",""],
["","you","","great!","","","","",""],
["","numa","","i can gather them up in a basket for her!","","","","",""],
["","","","oh, they're all dead and shriveled though","","","","",""],
["","","","they probably won't taste very  good","","","","",""],
["","","","this is probably a bad idea.","","","","",""],
["","you","","hey, it's the thought that counts.","","","","",""],
["","numa","","do you think?","","","","",""],
["","you","","yeah, probably","","","","",""],
["","numa","","that's not very reassuring ;;","numa_finished_food","","null","",""],
["numa_food4","you","","is the food all ready?","","","","",""],
["","numa","","yep, i'm almost done gathering the tastiest looking leaves for her","","","","",""],
["","you","","well, i guess i'll just [i]leaf[/i] you to it, then","","","","",""],
["","numa","","oh, you can stay if you want","","","","",""],
["","","","it's no problem","","","","",""],
["","","","…oh, was that a joke?","","","","",""],
["","you","","it was a joke, yeah","","","","",""],
["","numa","","haha","","","null","",""],
["numa_ready?","you","","so, are you going to talk to her?","","numa_finished_flowers and numa_finished_poem and numa_finished_food",['numa_ready', 'numa_not_ready'],"",""],
["numa_not_ready","","","oh, no, not yet!","","not numa_finished_flowers",['numa_r_flowers', 'numa_r_c1'],"",""],
["numa_r_flowers","","","i still haven't picked out the right flowers for her…","","","","",""],
["numa_r_c1","","","_pass","","not numa_finished_poem",['numa_r_poem', 'numa_r_c2'],"",""],
["numa_r_poem","","","i haven't finished the poem yet…","","","","",""],
["numa_r_c2","","","_pass","","not numa_finished_food",['numa_r_food', 'numa_r_end'],"",""],
["numa_r_food","","","i don't even know what food to get her!","","","","",""],
["numa_r_end","numa","","everything needs to be perfect.","","","","",""],
["","you","","hm, okay","","","null","",""],
["numa_ready","numa","","well… i guess…","","","","",""],
["","","","i have everything ready…","","","","",""],
["","_none","","numa looks over at a boquet of flowers, a handwritten card, and a basket of leaves","","","","",""],
["","numa","","it's just","","","","",""],
["","","","she's so pretty and confident and smart and","","","","",""],
["","","","she could do so much better than me…","","","","",""],
["","","","","","","","",[['don\'t worry, you\'ve got this!', 'numa_got'], ['maybe you could try a different approach', 'numa_much']]],
["numa_got","you","","you've got this, numa!","","","","",""],
["","","","she's going to be blown away by all the gifts","","","","",""],
["","numa","","do you think so?","","","","",""],
["","you","","absolutely","","","","",""],
["","numa","","great :)","","","","",""],
["","","","sorry for being such a worry worm…","","","","",""],
["","you","","it's ok","","","","",""],
["","_none","","numa takes a deep breath and gathers up the gifts in her arms.","","","","",""],
["","numa","","ok!! let's do this!!!","","","numa_meeting","",""],
["numa_much","you","","well, if you're worried, then…","","","","",""],
["","","","maybe it would be better to be more subtle?","","","","",""],
["","numa","","what do you mean?","","","","",""],
["","","","do you think i'm coming off too strong?","","","","",""],
["","","","oh no, what if she thinks i'm weird??","","","","",""],
["","","","i don't think i can do this","","","","",""],
["","you","","there's… no way that you're weirder than kyungsoon","","","","",""],
["","numa","","hm?","","","","",""],
["","you","","you can be weird together!","","","","",""],
["","","","like two peas in a weird pod","","","","",""],
["","numa","","…","","","","",""],
["","you","","…","","","","",""],
["","","","was that encouraging?","","","","",""],
["","numa","","not really","","","","",""],
["","","","sorry","","","","",""],
["","you","","either way, you can't back out now","","","","",""],
["","","","come on, let's head to the commons","","","","",""],
["","_none","","numa gulps","","","","",""],
["","numa","","ok…","","","","",""],
["numa_meeting","_none","numa_neutral","the two of you make your way to the commons. numa's hands are shaking as you approach the door.","numa_goto_commons","","","",""],
["","you","","are you ready?","","","","",""],
["","_none","","numa shakes her head.","","","","",""],
["","you","","go on, it'll be over soon","","","","",""],
["","","","just go in and tell her you like her.","","","","",""],
["","numa","",";;","","","","",""],
["","you","","just don't think about it! go in!!","","","","",""],
["","numa","","you're right, you're right. i can do this.","","","","",""],
["","_none","","numa takes a deep breath, then bursts through the door","","","","",""],
["","numa","_none","KYUNGSOON!","","","","",""],
["","_none","","you listen through the door.","","","","",""],
["","kyungsoon","","hm?","","","","",""],
["","numa","","i… um…","","","","",""],
["","kyungsoon","","…","","","","",""],
["","numa","","…","","","","",""],
["","","","kyungsoon i…","","","","",""],
["","","","i have something to tell you…","","","","",""],
["","kyungsoon","","yeah?","","","","",""],
["","_none","","you hear the library doors open.","oliver_hears_numa","","","",""],
["","oliver","","i heard yelling, is everything okay out here?","","","","",""],
["","","","oh, hi numa!","","","","",""],
["","","","what's all that stuff for?","","","","",""],
["","numa","","oh, it's, um","","","","",""],
["","oliver","","oh lord, what's that smell? is it the flowers?","","","","",""],
["","numa","","um…","","","","",""],
["","kyungsoon","","gross","","","","",""],
["","numa","","aaaaaa","","","","",""],
["","oliver","","numa, are you… okay?","","","","",""],
["","kyungsoon","","she was going to tell me something","","","","",""],
["","oliver","","oh, well don't let me get in the way!","","","","",""],
["","numa","","uhhhhhhhhhhh","","","","",""],
["","oliver","","go on","","","","",""],
["","numa","","kyungsoon…","","","","",""],
["","","","i…","","","","",""],
["","","","…","","","","",""],
["","_none","","you hear the sound of flowers hitting the floor, then numa bursts through the door and runs down the hallway.","commons_flowers","","","",""],
["","you","","numa?","","","","",""],
["","oliver","","…","","","","",""],
["","kyungsoon","","…","","","","",""],
["","oliver","","what was all that about?","","","","",""],
["","kyungsoon","","iuno","numa_crying","","null","",""],
["numa_cry","_none","","you can hear the faint sound of crying through the vent.","","","","",""],
["","you","","numa?","","not numa_consoled",['numa_cry_console', 'numa_cry_silent'],"",""],
["numa_cry_console","numa","","go away","numa_consoled","","","",""],
["","","","","","","","",[['don\'t feel bad', 'numa_cry_feel'], ['do you want to talk about it', 'numa_cry_talk'], ['you really messed that up', 'numa_cry_mess']]],
["numa_cry_silent","_none","","…","","","","",""],
["","","","seems like she doesn't want to talk.","","","null","",""],
["numa_cry_feel","you","","don't feel bad","","","","",""],
["","","","you tried your best, but oliver got in the way","","","","",""],
["","_none","","…","","","","",""],
["","you","","i bet kyungsoon is really enjoying those leaves","","","","",""],
["","_none","","…","","","","",""],
["","you","","i think she liked the flowers","","","","",""],
["","numa","","she called them gross!","","","","",""],
["","you","","gross in… a good way?","","","","",""],
["","","","like how \"bad\" used to mean good","","","","",""],
["","","","in the 80s","","","","",""],
["","_none","","you hear numa start crying harder","","","","",""],
["","","","","","","","",[['totally gross, duude', 'numa_cry_gross'], ['(just cut your losses)', 'numa_cry_end']]],
["numa_cry_gross","you","","like, that's totally gross, duuude","","","","",""],
["","_none","","…","","","","",""],
["numa_cry_end","","","it doesn't look like she's coming out any time soon.","","","null","",""],
["numa_cry_talk","you","","do you want to talk about it?","","","","",""],
["","numa","","no.","","","","",""],
["","you","","maybe later?","","","","",""],
["","numa","","i'm going to stay in here","","","","",""],
["","","","for eternity","","","","",""],
["","you","","don't do that!!","","","","",""],
["","_none","","…","","","numa_cry_end","",""],
["numa_cry_mess","you","","you totally messed that up","","","","",""],
["","numa","","i know that already!!","","","","",""],
["","you","","that's a mood","","","","",""],
["","_none","","you hear numa start crying harder","","","","",""],
["","","","she's definitely not coming out now.","","","null","",""]
]