if(state == states.DEAD) {
	path_end();
	return;
}
if(!instance_exists(obj_player)) {
	path_end();
	alarm_set(0, room_speed*0.2);
	return;
}

if(obj_player.state != PlayerStateLocked && state == states.MOVE) {
	if(distance_to_object(obj_player) <= detectionRange) {
		targX = obj_player.x;
		targY = obj_player.y;
		//Try to make path
		if(mp_grid_path(global.pathfindGrid, path, x, y, targX, targY, 1)) {
			path_start(path, walkSpd, path_action_stop, 0);
			motion_set(direction, 0);
			pathFailed = false;
		}
		else {
			pathFailed = true;
		}
	}
}
else if(state == states.ATTACKED) {
	var dir = point_direction(x, y, obj_player.x, obj_player.y) - 180;
	var len = TILEW*2;
	targX = x+lengthdir_x(len, dir);
	targY = y+lengthdir_y(len, dir);
	//Try to make path
	if(mp_grid_path(global.pathfindGrid, path, x, y, targX, targY, 1)) {
		path_start(path, walkSpd, path_action_stop, 0);
		motion_set(direction, 0);
		pathFailed = false;
	}
	else {
		pathFailed = true;
	}
	alarm_set(0, room_speed*0.5);
	return;
}
else {
	path_end();
	motion_set(direction, 0);
}
alarm_set(0, room_speed*0.2);