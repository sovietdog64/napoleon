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
else  {

	var inst = collision_point(x, y, obj_selectablePar,0,0);
	var dist = distance_to_object(obj_player);
	
	if(inst != noone && dist <= global.reachDistance)
		selectedObj = inst;
	else
		selectedObj = -1;
	
	if(LMOUSE_DOWN) {
		if(selectedObj != noone && dist <= global.reachDistance) {
			//If placeable being hovered can be broken with held item, and mouse btn is held down
			//Break le item
			if(selectedObj.object_index == obj_placeable) {
				if(is_instanceof(global.heldItem, selectedObj.item.breakingTool)) {
					selectedObj.hp -= global.heldItem.damage;
				}
				else
					selectedObj.leftClick();
			}
		}
		else
			selectedObj = -1;
	}
	
	if(RMOUSE_PRESSED) {
		if(selectedObj != -1 && dist <= global.reachDistance) {
			switch(selectedObj.object_index) {
				case obj_placeable: {
					selectedObj.rightClick();
				}break;
			}
		}
	}
}