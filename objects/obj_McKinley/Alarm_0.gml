if(state == states.DEAD)
	return;
alarm_set(0, room_speed*0.1);

checkForPlayer();
if(global.gamePaused || obj_player.state = PlayerStateLocked) {
	path_speed = 0;
}
else {
	path_speed = hspWalk;
}