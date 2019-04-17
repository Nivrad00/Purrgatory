extends Node

var raw_blocks = [
["screwdriver","_none","_none","you take the screwdriver.","_inv_screwdriver","","null","",""],
["vent","","","_pass","","numa_crying and not numa_quest_complete",['numa_cry', 'ventc'],"",""],
["ventc","","","_pass","","numa_snooped",['vent_locked', 'ventc2'],"",""],
["ventc2","","","_pass","","_inv_screwdriver",['vent_open', 'vent_closed'],"",""],
["vent_closed","","","the vent is secured by several screws. if you had a screwdriver, you could probably open it.","","","null","",""],
["vent_open","","","you use the screwdriver to loosen the cover.","opened_vent","","null","",""],
["vent_locked","","","you can't get in because numa took the screwdriver.","","","null","",""],
["numas_notebook","_none","_none","it says \"numa's diary\" on the front","","","","",""],
["","","","read it?","","","","",[['yes', 'notebook_read'], ['no', 'notebook_end']]],
["notebook_read","","","you open to a random page in the notebook.","","","","",""],
["","notebook","","day 458:\n$placeholder told me that the deathberries will ripen soon. i cant wait. (sarcasm.)","","","","",""],
["","","","i started pruning the thorns off the roses. i don't have anything else to do. maybe it'll save someone from a prick some day.","","","","",""],
["","","","i wish kyungsoon was here. she would probably think the deathberries are ugly though. (they are pretty ugly.)","","","","",""],
["","","","but everything is ugly in comparison to kyungsoon.","","","","",""],
["notebook_end","_none","","you put the notebook down.","","","null","",""],
["numas_drawing","_none","_none","it's a drawing of a snail and a hyena holding hands.","","","null","",""],
["flowers_etc","_none","_none","the gifts that numa dropped.","","","null","",""]
]