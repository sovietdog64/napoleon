function doAction() {
	if(place_meeting(x, y, obj_player)) {
		drawNotification(688, 471, "Use keys W,A,S,D to walk", c_yellow, room_speed*5, 3, fa_center, 0);
		global.spawnRoom = room;
		global.spawnX = obj_player.x;
		global.spawnY = obj_player.y;
		instance_destroy();
	}
}