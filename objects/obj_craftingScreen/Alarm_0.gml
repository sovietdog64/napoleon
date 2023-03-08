removeEmptyItems(craftingSlots)
//Putting item in result slot if crafted
for(var i=0; i<array_length(global.craftingRecipies); i++) {
	var craftingRecipie = global.craftingRecipies[i];
	var craftable = craftingRecipie.canCraft(craftingSlots) == true;
	if(craftable) {
		itemResultSlot[0] = duplicateItem(craftingRecipie.item);
		craftRecipie = craftingRecipie;
		break;
	}
	else if(itemsAreSame(itemResultSlot[0], craftingRecipie.item)) {
		itemResultSlot[0] = -1;
	}
	
	craftingRecipieBook = [];
	
	var invArr = array_concat(global.invItems, global.hotbarItems);
	var reqItems = array_concat(craftingRecipie.itemsRequired, craftingRecipie.toolsRequired);
	for(var j=0; j<array_length(reqItems); j++) {
		var isItemBool = isItem(reqItems[j])
		//Checking if should search by item sprite or item type
		var searchQuery = isItemBool ? reqItems[j].itemSpr : reqItems[j];
		var amount = isItemBool ? reqItems[j].amount : 1;
		
		var search = InvSearch(invArr, searchQuery, amount);
		
		if(search != -1) {
			array_push(craftingRecipieBook, craftingRecipie.item.itemSpr);
		}
	}
}


alarm_set(0, 2);