//List of all responses in the WHOLE GAME
function DialogueResponses(responseNum) {
	switch(responseNum) {
		case 0: break;
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
				var tanto = new Item(spr_tanto, 1, 3, itemAnimations.KNIFE_STAB);
				//Attempt to give tanto to player
				var gaveItem = giveItemToPlayer(tanto);
				//if inv too full, draw notification and drop tanto item on ground
				if(!gaveItem) {
					drawNotification(obj_player.x, obj_player.y - 100, "Inventory too full!", c_red, room_speed*3, 2, fa_center, 0);
					var inst = instance_create_layer(obj_player.x, obj_player.y, "Instances", obj_item);
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
		
		#region shop selling item case 7
		case 7: {
			purchaseItem(id.item, price, levelRequirement);
		} break;
		#endregion shop selling item case 7
		
		default: show_debug_message("Unexpected dialogue response") break;
	}
}