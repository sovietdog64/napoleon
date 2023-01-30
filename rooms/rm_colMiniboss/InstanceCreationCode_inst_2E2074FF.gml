function doAction() {
	if(place_meeting(x, y, obj_player)) {
		obj_player.y -= 100;
		room_goto(rm_plains);
	}
}