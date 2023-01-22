//List of all responses in the WHOLE GAME
function DialogueResponses(responseNum) {
	switch(responseNum) {
		case 0: break;
		case 1: newTextBox("Alright, here is what I've got. It ain't much, but it is something.", ["2:Musket (Level 5 req)", "3:Musket Ball (Musket ammunition) 10x"]); break;
		case 2: {
			//TODO: Check if player has enough money
			if(global.level >= 5) {
				var gaveItem = giveItemToPlayer(new Firearm(spr_musket, spr_musketBall, spr_musketBallProj, "Musket ball", 10, 100, musketReload, 0, 1, 150));
				if(gaveItem) {
					//TODO: Charge money
					newTextBox("There you go!\nHave a nice day!");
				}
				else
					drawNotification(obj_player.x, obj_player.y-100, "Inventory too full!", c_red, room_speed*3, 2, fa_center, 0);
			}
			else
				drawNotification(obj_player.x, obj_player.y-100, "Not enough levels (Level 5 required)!", c_red, room_speed*3, 2, fa_center, 0);
		} break;
		case 3: {
			//TODO: Check if player has enough money
			var gaveItem = giveItemToPlayer(new Item(spr_musketBall, 10, 0));
			if(gaveItem) {
				//TODO: Charge money
				newTextBox("There you go!\nHave a nice day!");
			}
			else
				drawNotification(obj_player.x, obj_player.y-100, "Inventory too full!", c_red, room_speed*3, 2, fa_center, 0);
		} break;
		default: show_debug_message("Unexpected dialogue response (jumpscare)") break;
	}
}