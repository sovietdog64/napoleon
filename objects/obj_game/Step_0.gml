global.heldItem = global.hotbarItems[global.equippedItem];

//Remove all items with amount of "0"
removeEmptyItems(global.invItems);
removeEmptyItems(global.hotbarItems);

with(all) {
	if(solid) {
		mp_grid_add_instances(global.pathfindGrid, id, 0);
	}
}