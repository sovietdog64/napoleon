for(var i=0; i<array_length(global.craftingRecipies); i++) {
	var craftingRecipie = global.craftingRecipies[i];
	var craftable = craftingRecipie.canCraft(craftingSlots) == true;
	if(craftable) {
		itemResultSlot[0] = duplicateItem(craftingRecipie.item);
		craftRecipie = craftingRecipie;
	}
	else if(itemsAreSimilar(itemResultSlot[0], craftingRecipie.item)) {
		itemResultSlot[0] = -1;
	}
}
removeEmptyItems(craftingSlots)
alarm_set(0, 2);