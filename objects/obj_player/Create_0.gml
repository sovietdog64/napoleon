startDepth = depth;
hsp = 0;//horizontal speed
vsp = 0;//vertical speed
hspWalk = 2;//horizontal speed when walking
vspJump = -16;//vertical speed when jumping
inDialogue = false;//bool stating whether the player is talking with an NPC.
invOpen = false;
clickedItem = -1;

invOpen = false;

maxHurtCooldown = room_speed;

minHspWalk = hspWalk;

runCooldown = 0;

hurtCooldown = 0;

followingSequences = array_create(0); //List of animations that follow the player.

lungeForward = false;

isHurt = false;

if(!variable_global_exists("hp"))global.hp = 5;//health
if(!variable_global_exists("maxHp"))global.maxHp = 5;//health
if(!variable_global_exists("dead"))global.dead = false;
leftAttackCooldown = 0;

global.spawnX = x;
global.spawnY = y;

global.stamina = 100;
global.maxStamina = 100;

state = PlayerStateFree;
attackState = attackStates.NONE;
lastState = state;

if(global.loadedGame) {
	x = global.spawnX;
	y = global.spawnY;
	global.loadedGame = false;
}

knockBack = function(damageX, damageY, kbLevel) {
	isHurt = true;
	lungeForward = false;
	hurtCooldown = maxHurtCooldown;
	var dir = point_direction(x, y, damageX, damageY)-180;
	hsp = (kbLevel*dcos(dir));
	vsp = (-kbLevel*dsin(dir));
}

//Vars for limb positions
shoulderB = new Point(x, y)
handB = new Point(x+10, y+10);
shoulderF = new Point(x, y);
handF = new Point(x+10, y+10);
hBOrigin = copyStruct(handB);
hFOrigin = copyStruct(handF);

handProgress = 0;
handDir = 0.3;

footProgress = 0;
footDir = 2;

footRadius = 3;

walkAnimSpd = 5;

//Legs
hipB = new Point(x-10, y-10);
footB = new Point(hipB.x, y+20);
hipF = new Point(x+10, y+10);
footF = new Point(hipF.x, y+20);

legLen = sprite_get_width(spr_playerLegB)*2;
fBOrigin = new Point(hipB.x, hipB.y+legLen);
fFOrigin = new Point(hipF.x, hipF.y+legLen);

animType = itemAnimations.NONE;