//@desc Update mouse over
x = mouse_x;
y = mouse_y;
handleScreenInput();

var inst = collision_point(x, y, obj_selectablePar,0,0);
var dist = distance_to_object(obj_player);
	
if(inst != noone && dist <= global.reachDistance)
	selectedObj = inst;
else
	selectedObj = noone;
	
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
		selectedObj = noone;
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