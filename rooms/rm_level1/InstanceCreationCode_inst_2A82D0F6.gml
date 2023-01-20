dialogueList = ["Hello!", "Would you mind looking through my muskets for sale?", "%options%"];
optionList = ["Flintlock Musket", "Musket Ball 10x"];
/*List of messages NPC will say depending on the clicked option. Use "%%" to separate messages.*/
/*Here, the NPC sayss test1, test1.1, and test 1.2 in separate dialogues when clicking on the first option.*/
/*The second option makes the NPC say one dialogue which says "test2"*/
optionReactionList = ["Thanks for your business. Have a great day!", "Thanks for your business. Have a great day!"];
npcName = "The Gunsmith";

optionActions = global.npcActions.options.gunsmith;