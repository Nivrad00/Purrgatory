extends Node

var raw_blocks = [
["flowers_init","_none","_none","_pass","","not flowers_played_once",['flowers_first', 'flowers_repeat'],"",""],
["flowers_first","you","_none","oh god, it smells really bad back here","numa_goto_flowerbed","","","",""],
["","numa","","i know, just try to hold your breath","flowers_played_once","","","",""],
["","you","","what do you need me to do?","","","","",""],
["","numa","","well, i know what kind of flower i'm looking for, but i always have a hard time finding it…","","","","",""],
["","","","if i describe what flower i need, could you find it for me?","","","","",""],
["","you","","okay, but we're going to have to be quick","","","","",""],
["","","","i don't think i can stand the smell for long","","","","",""],
["","numa","","okay, okay","","","","",""],
["","","","let's get started","","","","",""],
["","","","i just need 8 flowers, if that's okay","","","","",""],
["","","","ready?","","","","",""],
["","you","","ready.","flower_start_flag","","null","",""],
["flowers_fail","you","_none","argh, i can't do it any more","","","","",""],
["","","","it just smells too bad","","","","",""],
["","numa","","i'm sorry ;;","","","","",""],
["","you","","it's okay","","","","",""],
["","you","","maybe we can try again later?","","","","",""],
["","numa","","okay ;;","","","","",""],
["","you","numa_neutral","i don't know how you do that regularly.","flowers_goto_garden","","","",""],
["","numa","","you get used to it…","","","","",""],
["","","","kind of…","","","null","",""],
["flowers_succeed","","","_pass","","not numa_finished_flowers",['flowers_succeed_first', 'flowers_succeed_repeat'],"",""],
["flowers_succeed_first","numa","_none","that's all of them!","numa_finished_flowers","","","",""],
["","you","","woo, we did it!","","","","",""],
["","numa","","thanks, {player}","","","","",""],
["","","","i couldn't have done it without you!","","","","",""],
["","you","","glad to help.","","","","",""],
["","","","i think i need to go unclog my nose now","","","","",""],
["","numa","","sorry ;;","","","","",""],
["","you","numa_neutral","so, the flowers are settled now?","flowers_goto_garden","","","",""],
["","numa","","yeah, i think so","","","","",""],
["","","","i'll start arranging them asap","","","","",""],
["","","","they're going to look so beautiful in a boquet!","","","","",""],
["","you","","great.","","","","",""],
["","numa","","unless…","","","","",""],
["","","","what if kyungsoon doesn't like flowers","","","","",""],
["","","","what if she absolutely hates flowers","","","","",""],
["","","","what if she's allergic to flowers and that's why she died??","","","","",""],
["","","","oh no, i'm an idiot, why didn't i think of that earlier?","","","","",""],
["","you","","don't start second-guessing yourself now!","","","","",""],
["","","","i'm sure she's going to love them.","","","","",""],
["","numa","","ugh, you're right","","","","",""],
["","","","sorry","","","","",""],
["","you","","call me again if you need more help picking flowers.","","","","",""],
["","numa","","ok!","","","null","",""],
["flowers_repeat","you","_none","ugh, i forgot how bad it smells","numa_goto_flowerbed","","","",""],
["","numa","","i know, i know, sorry","","","","",""],
["","","","remember, i need 8 flowers.","","","","",""],
["","","","ready to start?","","","","",""],
["","you","","ready.","flower_start_flag","","null","",""],
["flowers_succeed_repeat","numa","_none","that's all of them!","","","","",""],
["","you","","woo, we did it!","","","","",""],
["","numa","","thanks again, {player}","","","","",""],
["","","","you're a flower picking natural :)","","","","",""],
["","you","","oh, it's nothing","","","","",""],
["","numa","numa_neutral","even more flowers to choose from…","flowers_goto_garden","","","",""],
["","","","this is great!","","","","",""],
["","you","","haha, glad to help","","","","",""],
["","numa","","come back again soon!","","","","",""],
["","","","i mean, if that's okay with you","","","","",""],
["","you","","of course, of course.","","","null","",""]
]