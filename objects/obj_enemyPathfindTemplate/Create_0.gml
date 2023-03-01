init = true;
#region default enemy stuff
hsp = 0;
vsp = 0;
walkSpd = random_range(1, 2);


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

#endregion default enemy stuff
if(!layer_exists("Enemies")) {
	layer_create(layer_get_depth("Instances")+1, "Enemies");
	layer = layer_get_id("Enemies");
}

#region pathfinding
alert = false;
detectionRange = TILEW*7;

attackDist = TILEW;
maxAtkCooldown = room_speed;

deadTime = 0;

knockbackTime = 0;

path = path_add();
path_endaction = path_action_stop;

pathFailed = false;

targX = 0;
targY = 0;

alarm_set(0, 10);

#endregion pathfinding


