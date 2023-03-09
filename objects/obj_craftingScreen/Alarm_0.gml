///@description crafting functionality & recipies
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
	
	//Adding items to recipie book
	var invArr = array_concat(global.invItems, global.hotbarItems);
	var reqItems = craftingRecipie.itemsRequired;
	if(is_array(craftingRecipie.toolsRequired))
		reqItems = array_concat(craftingRecipie.itemsRequired, craftingRecipie.toolsRequired);
	for(var j=0; j<array_length(reqItems); j++) {
		//If already added to recipie book, then continue
		if(array_contains(global.craftingRecipieBook, craftingRecipie.item.itemSpr))
			continue;
		var isItemBool = isItem(reqItems[j])
		//Checking if should search by item sprite or item type
		var searchQuery = isItemBool ? reqItems[j].itemSpr : reqItems[j];
		var amount = isItemBool ? reqItems[j].amount : 1;
		
		var search = InvSearch(invArr, searchQuery, amount);
		
		if(search != -1) {
			array_push(global.craftingRecipieBook, craftingRecipie.item.itemSpr);
			var numOfBtns = array_length(btnList);
			var hoverText = getHoverTextCrafting(reqItems, craftingRecipie.item);
			
			array_push(btnList, new GuiButton(
				craftingRecipie.item.itemSpr,0,
				(RESOLUTION_W-300)+26*(numOfBtns%8), 40+26*(numOfBtns div 8),,
				hoverText,
				0.4,0.4
			))
		}
	}
}


alarm_set(0, 2);