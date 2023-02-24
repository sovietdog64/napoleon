if(state == states.DEAD) {
	path_end();
	return;
}
if(!instance_exists(obj_player)) {
	alarm_set(0, room_speed*0.2);
	return;
}

if(!global.gamePaused && obj_player.state != PlayerStateLocked && state == states.MOVE) {
	if(distance_to_object(obj_player) <= detectionRange) {
		var dir = point_direction(x, y, obj_player.x, obj_player.y);
		//Try to make path
		if(mp_grid_path(global.pathfindGrid, path, x, y, obj_player.x, obj_player.y, 1)) {
			path_start(path, hspWalk, path_action_stop, 0);
			motion_set(direction, 0);
		}
		else	//if no path, try moving anyways
		{
			move_towards_point(obj_player.x, obj_player.y, hspWalk);
		}
	}
}
else if(state == states.ATTACKED) {
	var dir = point_direction(x, y, obj_player.x, obj_player.y) - 180;
	var len = TILEW*2;
	var xx = lengthdir_x(len, dir);
	var yy = lengthdir_y(len, dir);
	//Try to make path
	if(mp_grid_path(global.pathfindGrid, path, x, y, obj_player.x, obj_player.y, 1)) {
		path_start(path, hspWalk, path_action_stop, 0);
		motion_set(direction, 0);
	}
	else  //if no path, try moving anyways
	{
		move_towards_point(xx, yy, hspWalk);
	}
	alarm_set(0, room_speed*0.5);
	return;
}
else {
	path_end();
	motion_set(direction, 0);
}
alarm_set(0, room_speed*0.2);