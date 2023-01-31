/// @description Update path
alarm_set(0, room_speed*0.4);
if(!instance_exists(obj_player))
	return;
if(obj_player.state = PlayerStateLocked)  {
	path_end();
	return;
}
	
var distToPlayer = distance_to_point(obj_player.x, obj_player.y);
if(distToPlayer > detectionRange)
	return;
	
targX = obj_player.x
targY = obj_player.y

path_delete(path);

path = path_add();

//Make path
var success = mp_grid_path(grid, path, x,y, targX, targY, 0);
var len = 1;
if(!success) {
	x = xprevious;
	y = yprevious;
}
//while(!success && len < 200) {
//	for(var i=0; i<360; i += 45) {
//		success = mp_grid_path(grid, path, x+lengthdir_x(len, i),y+lengthdir_x(len, i), targX, targY, 0);
//		if(success)
//			break;
//	}
//	len ++;
//}

//Walk on path
path_start(path, hspWalk, path_action_stop, true);
