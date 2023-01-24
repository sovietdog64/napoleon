//List of all responses in the WHOLE GAME
function DialogueResponses(responseNum) {
	switch(responseNum) {
		case 0: break;
		#region gunsmith case 1-3
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
		#endregion gunsmith 1-3
		
		#region liam case 4
		case 4 : {
			var questStruct = new Quest("Spider Slayer", "Kill 10 spiders", 30, 5, 0, 10, "Liam");
			var success = assignQuest(questStruct);
			if(success == 0) {
				newTextBox("Spider Slayer is currently active!", undefined, 2);
			}
			else if(success == -1) {
				newTextBox("You already completed this quest!", undefined, 2);
			}
		}
		#endregion liam case 4
		
		default: show_debug_message("Unexpected dialogue response") break;
	}
}