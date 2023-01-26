#region default enemy stuff
hsp = 0;
vsp = 0;
hspWalk = random_range(5, 6);
vspJump = -10;
jumpCooldown = room_speed*0.7;
hp = 10;
maxHp = hp;

drops = array_create(0);

lungeForward = false;

detectionRange = 800;

xpDrop = 10;
if(global.level >= 10)
	xpDrop = 5;

isHurt = false;

timeSinceFoundPlayer = 0;

#endregion default enemy stuff
if(!layer_exists("Enemies")) {
	layer_create(layer_get_depth("Instances")+1, "Enemies");
	layer = layer_get_id("Enemies");
}

#region pathfinding
//Dimensions of grid to check (scales with sprite dimensions)
gridCheckWidth = 16;
gridCheckHeight = 16;


//Grid to pathfind on (Enemy collision mask must be less than size of grid cell. in this example, enemy is less than 16x16)
grid = mp_grid_create(0, 0, room_width/gridCheckWidth, room_height/gridCheckHeight, gridCheckWidth, gridCheckHeight);
//Add solids to collide with
mp_grid_add_instances(grid, obj_solid, 0);

//hitX/hitY is x/y pos of the object or hitbox that hitting this enemy. call this function when u want to hit an enemy back
knockBack = function(hitX, hitY, kbSpeed) {
	hsp = 0;
	vsp = 0;
	var dir = point_direction(x, y, hitX, hitY)-180;
	//Determine vector of knockback (i like using the "dist*sin-cos" thing)
	var xSpd = kbSpeed*dcos(dir);
	var ySpd = -kbSpeed*dsin(dir);
	isHurt = true;
	hsp = xSpd;
	vsp = ySpd;
}

path = path_add();

alarm[0] = 1;

targX = obj_player.x;
targY = obj_player.y;

resetPath = function(targetX = obj_player.x, targetY = obj_player.y) {
	targX = targetX;
	targY = targetY;

	path_delete(path);
	path = path_add();

	//Make path
	mp_grid_path(grid, path, x,y, targX, targY, 1);

	//Walk on path
	path_start(path, hspWalk, path_action_stop, true);
}
	
spawnLocX = x;
spawnLocY = y;

#endregion pathfinding