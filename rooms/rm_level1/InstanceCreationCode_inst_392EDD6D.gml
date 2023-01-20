dialogueList = ["Hello!", "Welcome to the Americas!", "We are really busy right now with imports...", "But feel free to make yourself at home here!"];
optionList = ["testItem", "testItem2", "test3"];
/*List of messages NPC will say depending on the clicked option. Use "%%" to separate messages.*/
/*Here, the NPC sayss test1, test1.1, and test 1.2 in separate dialogues when clicking on the first option.*/
/*The second option makes the NPC say one dialogue which says "test2"*/
optionReactionList = ["Thanks for purchasing!%%Have a great day.", "test2%%", "test thingy%%"];
npcName = "Franklin";

//Template code for reacting to messages
function doOptionActions(optionClicked) {
	if(optionClicked == 0) {
		//Remove this default code if you don't want dialogue after clicking an option
		optionReactionIndex = optionClicked;
		currentReactionMessages = string_split(optionReactionList[optionReactionIndex], "%%")
		//Add extra actions here if necessary
	}
	if(optionClicked == 1) {
		//Remove this default code if you don't want dialogue after clicking an option
		optionReactionIndex = optionClicked;
		currentReactionMessages = string_split(optionReactionList[optionReactionIndex], "%%")
		//Add extra actions here if necessary
	}
	if(optionClicked == 2) {
		//Remove this default code if you don't want dialogue after clicking an option
		optionReactionIndex = optionClicked;
		currentReactionMessages = string_split(optionReactionList[optionReactionIndex], "%%")
		var inst = instance_create_layer(x, y+30, "Instances", obj_item);
		inst.sprite_index = spr_item;
		//Add extra actions here if necessary
	}
	//Add if statement for each option
	if(optionClicked != undefined) canShowOptions = false;
}