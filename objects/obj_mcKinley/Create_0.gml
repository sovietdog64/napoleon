init = true;
#region default enemy stuff
hsp = 0;
vsp = 0;
walkSpd = 7;


maxHp = 150;
hp = maxHp;	

noCollideDmg = true;

state = states.MOVE;

lungeForward = false;

detectionRange = 600;

xpDrop = 5;

itemDrops = [new FirearmAuto(gunTypes.RIFLE, spr_m16, spr_556x45mm, spr_556x45Proj, "5.56x45mm", 10, 250, 8, m16Reload, 30, spr_m16Mag, spr_m16Empty), new Item(spr_556x45mm, 120, 10)];

knife = new Item(spr_knife, 1, 1, itemAnimations.KNIFE_STAB);

equipped = knife;

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
detectionRange = 300;

//Distance from player where enemy stops to attack
attackDist = sprite_width;

deadTime = 0;

path = path_add();

var w = ceil(room_width/sprite_width);
var h = ceil(room_height/sprite_height);
//Create grid fir enemy pathfinding
grid = mp_grid_create(0, 0, w, h, sprite_width, sprite_height);

//Add solids to grid
mp_grid_add_instances(grid, obj_solid, 0);

alarm_set(0, 10);

#endregion pathfinding