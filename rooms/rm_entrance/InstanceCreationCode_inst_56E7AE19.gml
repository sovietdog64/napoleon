function doAction() {
	if(place_meeting(x, y, obj_player)) {
		instance_destroy();
		room_goto_next();
		return;
	}
}