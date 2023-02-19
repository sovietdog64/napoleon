global.heldItem = global.hotbarItems[global.equippedItem];

//Remove all items with amount of "0"
removeEmptyItems(global.invItems);
removeEmptyItems(global.hotbarItems);