//Setting color blend of placeable sprite if can be placed/cannot
if (isPlaceableItem(global.heldItem)) {
	//use the object following the mouse to check if collisions are stopping
	//the placeable from being placed.
	with(mouseFollower) {
		sprite_index = global.heldItem.placedSprite;
		//If being blocked, do red blend & dont allow player to place
		//else, do green blend & allow player to place
		if(!place_free(roundToTile(x, TILEW/2), roundToTile(y, TILEW/2))) {
			other.placeableColorBlend = c_red;
			global.canPlaceItem = false;
		}
		else {
			other.placeableColorBlend = c_green;
			global.canPlaceItem = true;
		}
		sprite_index = -1;
	}
}