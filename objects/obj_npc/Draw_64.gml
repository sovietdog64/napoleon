///@description This is an NPC template
if(instance_exists(obj_game) && obj_game.gamePaused || obj_player.invOpen) 
	return;

if(!instance_exists(obj_game))
	return;
var inst = instance_nearest(x, y, obj_player);

try{doNPCDrawGUIActions(id);}
	catch(err) {show_debug_message(err.message);}
if(skipDefaultActions)
	return;
//Draws query box asking the player if they want to talk to the NPC.
if(!talk && inst != noone && distance_to_point(inst.x, inst.y) <= 100) {
	if(!obj_player.inDialogue){
		drawNPCQueryBox(npcName);
		if(keyboard_check_pressed(vk_enter)) {
			talk = !talk;
			dialogueIndex = 0;
		}
	}
}

//If the player decides to talk to the NPC, draw the message.
if(talk) {
	doneTalking = false;
	if(dialogueList[dialogueIndex] != "%options%") {
		drawNPCMessage(npcName, dialogueList[dialogueIndex], c_gray, c_black);
		//If space btn pressed, then move to next line of dialogue.
		if(mouse_check_button_pressed(mb_left)) {
			dialogueIndex++;
			//Exit from dialogue once out of lines to say.
			if(dialogueIndex >= array_length(dialogueList)) {
				talk = !talk;
				dialogueIndex = 0;
				doneTalking = true;
				obj_player.inDialogue = false;
			}
		}
		//If Q btn pressed, then exit from dialogue.
		else if(keyboard_check_pressed(ord("Q"))) {
			talk = !talk;
			dialogueIndex = 0;
			obj_player.inDialogue = false;
		}
	}
	else {
		//Shows options. When one is clicked, stop showing options and do actions.
		if(canShowOptions) {
			var temp = drawOptions(optionList)
			if(!is_numeric(optionClicked))optionClicked = temp;
			try{optionActions(id);}
				catch(err) {};
		} 
		else if (!canShowOptions) {//Drawing messages the NPC has depending on the option clicked.
			//Remove blank dialogues
			for(var i=0; i<array_length(currentReactionMessages); i++) {
				if(currentReactionMessages[i] == "") {
					array_delete(currentReactionMessages, i, 1);
				}
			}
			if(!shouldReact) return;
			doneTalking = false;
			drawNPCMessage(npcName, currentReactionMessages[reactionIndex], c_gray, c_black);
			if(mouse_check_button_pressed(mb_left)) {//Pressing space moves to the next message the NPC has.
				reactionIndex++
				if(reactionIndex >= array_length(currentReactionMessages)) {
					doneTalking = true;
					talk = false;
					dialogueIndex = 0;
					canShowOptions = true;
					optionReactionIndex = -1;
					currentReactionMessages = undefined;
					reactionIndex = 0;
					obj_player.inDialogue = false;
				}
			}
		}
	}
}