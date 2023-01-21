function doAction() {
	if(place_meeting(x, y, obj_player)) {
		global.spawnX = obj_player.x;
		global.spawnY = obj_player.y;
		global.spawnRoom = room;
		
		instance_destroy();
	}
}