extends Node

var raw_blocks = [
["examine_book","_none","book","the book you checked out from oliver.","","","","","",""],
["","","","it's meows all the way through.","","","null","","",""],
["examine_screwdriver","_none","_none","it's a screwdriver.","","","null","","",""],
["examine_commons_key","_none","_none","the key that kyungsoon had.","","","null","","",""],
["examine_battery1","_none","_none","a battery.","","","null","","",""],
["examine_battery2","_none","_none","a battery.","","","null","","",""],
["examine_chess_letter","_none","_none","oliver's next chess move, for tori.","","","null","","",""],
["examine_natalies_books","_none","_none","some books natalie needs to return to oliver.","","","null","","",""],
["examine_draw_a_paw","_none","_none","it's one of those old draw-a-paws.","_goto_draw_a_paw","","","","",""],
["","","","(click and rotate the knobs or use the QWOP keys to draw!)","","","null","","",""],
["examine_candle","_none","_none","a candle that natalie gave you.","","","null","","",""],
["examine_snowglobe1","_none","_none","a cool snowglobe with a cat in it.","","","null","","",""],
["examine_snowglobe2","_none","_none","a pair of cool snowglobes.","","","null","","",""],
["examine_snowglobe3","_none","_none","a trio of cool snowglobes.","","","null","","",""],
["examine_snowglobe4","_none","_none","a quartet of cool snowglobes.","","","null","","",""],
["examine_snowglobe5","_none","_none","your steadily growing collection of cool snowglobes.","","","null","","",""],
["examine_snowglobe6","_none","_none","half a dozen cool snowglobes.","","","null","","",""],
["examine_snowglobe7","_none","_none","more cool snowglobes than your wildest dreams.","","","null","","",""],
["examine_business_card","_none","business_card","it's a business card for \"lucifur.\"","","called_lucifur",['null', 'examine_business_card1'],"","",""],
["examine_business_card1","","","huh, it has a phone number...","_quest_call_lucifur","","null","","",""],
["examine_ladder","_none","_none","a ladder.","","","","","",""],
["","","","it's pretty awkward to carry around...","","","null","","",""],
["examine_cat_toy","_none","_none","a cat toy shaped like a fish.","","","null","","",""]
]