global.hp = 5;
global.dead = false;
image_alpha = 1;
global.setPosToSpawnPos = true;
if(enteredX != 0) {
	x = enteredX;
	y = enteredY;
}
room_goto(global.spawnRoom);