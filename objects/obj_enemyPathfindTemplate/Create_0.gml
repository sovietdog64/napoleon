hsp = 0;
vsp = 0;
hspWalk = random_range(2, 4);
vspJump = -10;
jumpCooldown = room_speed*0.7;
hp = 5;
maxHp = hp;

drops = array_create(0);

lungeForward = false;

detectionRange = 500;

xpDrop = 5;
if(global.level >= 5)
	xpDrop = 1;

isHurt = false;

timeSinceFoundPlayer = 0;

if(!layer_exists("Enemies")) {
	layer_create(layer_get_depth("Instances")+1, "Enemies");
	layer = layer_get_id("Enemies");
}

//hitX/hitY is x/y pos of the object or hitbox that hitting this enemy. call this function when u want to hit an enemy back
knockBack = function(hitX, hitY, kbSpeed) {
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
	mp_grid_path(obj_setupPathway.grid, path, x,y, targX, targY, 1);

	//Walk on path
	path_start(path, hspWalk, path_action_stop, true);
}
	
spawnLocX = x;
spawnLocY = y;