grv = 0.5;
hsp = 0;
vsp = 0;
hspWalk = -random_range(2, 4);
vspJump = -10;
jumpCooldown = room_speed*0.7;
hp = 5;
maxHp = hp;

clingX = x;
clingY = y;

drops = array_create(0);

lungeForward = false;

xpDrop = 5;
if(global.level >= 5)
	xpDrop = 1;

isHurt = false;

if(!layer_exists("Enemies")) {
	layer_create(layer_get_depth("Instances")+1, "Enemies");
	layer = layer_get_id("Enemies");
}

wallCrawling = false;

rTargX = array_create(4, 0);
rTargY = array_create(4, 0);
lTargX = array_create(4, 0);
lTargY = array_create(4, 0);
lDegrees = array_create(4, -1);
rDegrees = array_create(4, -1);