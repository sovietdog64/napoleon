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
else if(isItem(global.heldItem)) {
	//If placeable being hovered can be broken with current item, and mouse btn is held down
	//Break le item
	if(LMOUSE_DOWN) {
		var inst = collision_point(x, y, obj_placeable,0,0);
		if(inst != noone && is_instanceof(global.heldItem, inst.item.breakingTool)) {
			var dist = distance_to_object(obj_player);
			if(dist <= global.reachDistance)
				inst.hp -= global.heldItem.damage;
		}
	}
}