if(state = states.DEAD)
	return;
alarm_set(0, room_speed*0.2);

if(global.gamePaused || obj_player.state = PlayerStateLocked) {
	if(distance_to_object(obj_player) <= detectionRange) {
		if(mp_potential_path(path, obj_player.x, obj_player.y, hspWalk, 4, 0))
			path_start(path, hspWalk, path_action_stop, 0)
	}
}
else {
	path_end();
}