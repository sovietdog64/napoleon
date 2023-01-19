/// @description Load last state of room when room started
loadRoom();
if(global.setPosToSpawnPos) {
	obj_player.x = global.spawnX;
	obj_player.y = global.spawnY;
	obj_player.safeX = global.spawnX;
	obj_player.safeY = global.spawnY;
	saveGame();
	global.setPosToSpawnPos = false;
}