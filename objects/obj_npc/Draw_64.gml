///@description This is an NPC template
if(instance_exists(obj_game) && global.gamePaused || global.invOpen) 
	return;

if(!instance_exists(obj_game))
	return;
var inst = instance_nearest(x, y, obj_player);

if(obj_player.state == PlayerStateLocked)
	return;

//Draws query box asking the player if they want to talk to the NPC.
if(!talk && inst != noone && distance_to_point(inst.x, inst.y) <= 100) {
	drawNPCQueryBox(npcName);
	//If playe decides to intereact, speak.
	if(keyboard_check_pressed(vk_enter)) {
		for(var i=0; i<array_length(dialogueList); i++) {
			//If is array, it is has to be a list of player responses
			if(is_array(dialogueList[i])) {
				var title = "";
				var playerResponses = array_create(0);
				//Loop through all player responses
				for(var j=0; j<array_length(dialogueList[i]); j++) {
					var val = dialogueList[i][j];
					//First item in array is supposed to be the title of the list of responses.
					if(j == 0) {
						title = val;
						continue;
					}
					//Anything else is a player response
					else
						array_push(playerResponses, val);
				}
				newTextBox(title, playerResponses);
			}
			//If it is not an array, then it is just a regular NPC message
			else
				newTextBox(dialogueList[i]);
		}
	}
}
return;
