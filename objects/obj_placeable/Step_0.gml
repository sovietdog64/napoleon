if(global.screenOpen || global.gamePaused)
	return;
	
if(RMOUSE_PRESSED) {
	var hovered = point_in_rectangle(
		mouse_x, mouse_y,
		bbox_left,bbox_top,bbox_right,bbox_bottom,
	)
	if(hovered) 
		rightClick();
}
else if(LMOUSE_PRESSED) {
	var hovered = point_in_rectangle(
		mouse_x, mouse_y,
		bbox_left,bbox_top,bbox_right,bbox_bottom,
	);
	
	if(hovered)
		leftClick();
}