function doAction() {
	if(place_meeting(x, y, obj_player)) {
		drawNotification(1635, 74, "Left click to use items", c_yellow, room_speed*5, 3, fa_center, 0);
		drawNotification(2130, 542, "Use keys 1,2,3 to swap between items", c_yellow, room_speed*7, 3, fa_center, 0);
		instance_destroy();
	}
}