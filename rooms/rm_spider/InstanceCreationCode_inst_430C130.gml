function doAction() {
	if(place_meeting(x, y, obj_player)) {
		obj_player.x = 289;
		obj_player.y = 170;
		room_goto(rm_level1);
		instance_destroy();
	}
}