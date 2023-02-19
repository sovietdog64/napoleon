if(!isItem(itemResultSlot[0]))
	for(var i=0; i<array_length(global.craftingRecipies); i++) {
		var craftingRecipie = global.craftingRecipies[i];
		var shouldCraft = craftingRecipie.canCraft(craftingSlots) == true;
		if(shouldCraft) {
			var itemCrafted  = craftingRecipie.craftItem(craftingSlots);
			itemResultSlot[0] = itemCrafted;
		}
	}
removeEmptyItems(craftingSlots)
alarm_set(0, 2);