init = true;
#region default enemy stuff
hsp = 0;
vsp = 0;
hspWalk = random_range(1, 3);
vspJump = -10;
jumpCooldown = room_speed*0.7;
maxHp = 5;
hp = maxHp;	

state = states.MOVE;

lungeForward = false;

detectionRange = TILEW*10;

xpDrop = 5;
if(global.level >= 5)
	xpDrop = 1;

isHurt = false;

maxAttackCooldown = room_speed*0.8;
attackCooldown = maxAttackCooldown;

timeSinceFoundPlayer = 0;

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

#endregion default enemy stuff
if(!layer_exists("Enemies")) {
	layer_create(layer_get_depth("Instances")+1, "Enemies");
	layer = layer_get_id("Enemies");
}

#region pathfinding
alert = false;
detectionRange = TILEW*7;

attackDist = TILEW*2;
maxAtkCooldown = room_speed;

deadTime = 0;

knockbackTime = 0;

path = path_add();

alarm_set(0, 10);

#endregion pathfinding


