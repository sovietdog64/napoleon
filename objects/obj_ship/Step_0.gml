if(distance_to_point(2180, y) > 10) {
	move_towards_point(2180, y, distance_to_point(2180, y)/50);
	obj_player.x = x + sprite_width*0.8;
	obj_player.y = y - abs(obj_player.sprite_width/2);
} else if(!hasSetSpawnPoint) {
	hasSetSpawnPoint = true;
	motion_set(0,0);
	global.spawnX = obj_player.x;
	global.spawnY = obj_player.y;
	global.spawnRoom = room;
}