hsp = 0;
vsp = 0;
hspWalk = -random_range(2, 4);
vspJump = -10;
jumpCooldown = room_speed*0.7;
hp = 5;
maxHp = hp;

lungeForward = false;

xpDrop = 5;
if(global.level >= 5)
	xpDrop = 1;

isHurt = false;

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
