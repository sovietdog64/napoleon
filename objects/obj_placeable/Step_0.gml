if(global.screenOpen || global.gamePaused)
	return;

var dist = distance_to_object(obj_player);
if(RMOUSE_PRESSED &&  dist <= 20) {
	var hovered = point_in_rectangle(
		mouse_x, mouse_y,
		bbox_left,bbox_top,bbox_right,bbox_bottom,
	)
	if(hovered) 
		rightClick();
}
else if(LMOUSE_PRESSED && dist <= 20) {
	var hovered = point_in_rectangle(
		mouse_x, mouse_y,
		bbox_left,bbox_top,bbox_right,bbox_bottom,
	);
	
	if(hovered)
		leftClick();
}

if(hp <= 0) {
	with(instance_create_layer(x, y, "Instances", obj_item))
		item = other.item;
	instance_destroy()
}

prevHp = hp;