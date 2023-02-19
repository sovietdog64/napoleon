//@desc Update mouse over
x = mouse_x;
y = mouse_y;
handleScreenInput();

//Setting color blend of placeable sprite if can be placed/cannot
if (isPlaceableItem(global.heldItem)) {
	//use the object following the mouse to check if collisions are stopping
	//the placeable from being placed.
	sprite_index = global.heldItem.placedSprite;
	//If being blocked, do red blend & dont allow player to place
	//else, do green blend & allow player to place
	if(!place_free(roundToTile(x, TILEW/2), roundToTile(y, TILEW/2))) {
		placeableColorBlend = c_red;
		global.canPlaceItem = false;
	}
	else {
		placeableColorBlend = c_green;
		global.canPlaceItem = true;
	}
	sprite_index = -1;
}