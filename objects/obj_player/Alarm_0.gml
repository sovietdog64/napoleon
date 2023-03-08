global.hp = global.maxHp;
image_alpha = 1;
global.dead = false;
x = global.spawnX;
y = global.spawnY;
if(instance_exists(obj_dungeonDoor))
	obj_dungeonDoor.solid = false;