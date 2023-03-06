//List of all responses in the WHOLE GAME
function DialogueResponses(responseNum) {
	switch(responseNum) {
		case 0: break;
		#region shop selling item case 1
		case 1: {
			//Attempt to charge money. If not enough money, 
			if(!InvRemovePlayer(spr_gold, price)) {
				newTextBox("Not enough money!", ,2); //show textbox saying so.
				return;
			}
	
			//Give item to player
			var _item = duplicateItem(item);
			if(!giveItemToPlayer(_item)) {
				newTextBox("Not enough inventory space!", , 2);
				return;
			}
			else {
				stock -= item.amount;
	
				if(stock <= 0)
					instance_destroy()
			}
		} break;
		#endregion shop selling item case 7
		
		default: show_debug_message("Unexpected dialogue response") break;
	}
}