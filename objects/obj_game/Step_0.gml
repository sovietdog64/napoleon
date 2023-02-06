global.heldItem = global.hotbarItems[global.equippedItem];
//Removing items that have an amount of 0 in inventory
for(var i=0; i<array_length(global.hotbarItems); i++) {
	var item = global.hotbarItems[i];
	if(!isItem(item))
		continue;
	if(item.amount <= 0) {
		global.hotbarItems[i] = -1;
	}
}
//Removing items that have an amount of 0 in inventory
for(var i=0; i<array_length(global.invItems); i++) {
	var item = global.invItems[i];
	if(!isItem(item))
		continue;
	if(item.amount <= 0) {
		global.invItems[i] = -1;
	}
}