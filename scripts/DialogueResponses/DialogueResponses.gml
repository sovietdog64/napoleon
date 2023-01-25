//List of all responses in the WHOLE GAME
function DialogueResponses(responseNum) {
	switch(responseNum) {
		case 0: break;
		#region gunsmith case 1-3
			case 1: newTextBox("Alright, here is what I've got. It ain't much, but it is something.", ["2:Musket (Level 5 req)", "3:Musket Ball (Musket ammunition) 10x"]); break;
			case 2: {
				//TODO: Check if player has enough money
				if(global.level >= 5) {
					var gaveItem = giveItemToPlayer(new Firearm(spr_musket, spr_musketBall, spr_musketBallProj, "Musket ball", 10, 200, musketReload, 0, 1, 150));
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
		//Assigning spider slayer quest
		case 4 : {
			var questStruct = new Quest("Spider Slayer", "Kill 10 spiders", 30, 5, 0, 10, "Liam");
			var success = assignQuest(questStruct);
			if(success == 0) {
				newTextBox("Spider Slayer is currently active!", undefined, 2);
			}
			else if(success == -1) {
				newTextBox("You already completed this quest!", undefined, 2);
			}
		} break;
		#endregion liam case 4
		
		#region Will case 5-6
		//If player gave 10 musket ball, make npc give tanto knife in return
		case 5: {
			var item = getItemFromInv(spr_musketBall, 10);
			if(!isItem(item))
				newTextBox("Not enough Musket Balls!");
			else {
				obj_npcWill.disappear = true;
				item.amount -= 10;
				newTextBox("Thank you! You are a life saver");
				newTextBox("You know what, here. Take this tanto knife.");
				newTextBox("Using that is much better than punchin' away at those unearthly animals");
				
				newTextBox("*Didn't the tanto get popular in America at the 1900s?*", undefined, 3);
				newTextBox("*Something seems really fishy...*", undefined, 3);
				var tanto = new Item(spr_tanto, 1, 3);
				//Attempt to give tanto to player
				var gaveItem = giveItemToPlayer(tanto);
				//if inv too full, draw notification and drop tanto item on ground
				if(!gaveItem) {
					drawNotification(obj_player.x, obj_player.y - 100, "Inventory too full!", c_red, room_speed*3, 2, fa_center, 0);
					var inst = instance_create_layer(obj_player.x, obj_player.y, "Interactables", obj_item);
					inst.item = tanto;
				}
			}
		} break;
		//If player does not give 10 musket ball, show textbox saying that npc might give something in return.
		case 6: {
			newTextBox("Aw man. Well, good luck on your adventures");
			newTextBox("*This person might give something in return for the ammunition*", undefined, 3);
		} break;
		#endregion Will case 5-6
		
		default: show_debug_message("Unexpected dialogue response") break;
	}
}