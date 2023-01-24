/// @description Update path
if(!instance_exists(obj_player))
	return;
if(obj_player.state = PlayerStateLocked) 
	return;
	
var distToPlayer = distance_to_point(obj_player.x, obj_player.y);
if(distToPlayer > detectionRange)
	return;
	
targX = obj_player.x
targY = obj_player.y

path_delete(path);
path = path_add();

//Make path
mp_grid_path(grid, path, x,y, targX, targY, 1);

//Walk on path
path_start(path, hspWalk, path_action_stop, true);

alarm_set(0, room_speed*0.4);