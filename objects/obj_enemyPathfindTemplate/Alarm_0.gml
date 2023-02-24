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
		if(mp_grid_path(global.pathfindGrid, path, x, y, obj_player.x, obj_player.y, 1))
			path_start(path, hspWalk, path_action_stop, 0);
		else if(place_free(x + lengthdir_x(hspWalk, dir),
							y + lengthdir_y(hspWalk, dir)))	
		{
			var dir = point_direction(x, y, obj_player.x, obj_player.y);
			x += lengthdir_x(hspWalk, dir);
			y += lengthdir_y(hspWalk, dir);
		}
	}
}
else if(state == states.ATTACKED) {
	var dir = point_direction(x, y, obj_player.x, obj_player.y) - 180;
	var len = TILEW*2;
	var xx = lengthdir_x(len, dir);
	var yy = lengthdir_y(len, dir);
	if(mp_grid_path(global.pathfindGrid, path, x, y, xx, yy, 1))
		path_start(path, hspWalk, path_action_stop, 0);
	else if(place_free(x + lengthdir_x(hspWalk, dir),
						y + lengthdir_y(hspWalk, dir)))
	{
		x += lengthdir_x(hspWalk, dir);
		y += lengthdir_y(hspWalk, dir);
	}
}
else {
	path_end();
}
alarm_set(0, room_speed*0.2);