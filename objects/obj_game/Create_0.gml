global.gamePaused = false;
persistent = true;

global.loadedGame = false;

drawPauseScreen = false;

global.invItems = array_create(8, -1);
global.hotbarItems = array_create(3, -1);
global.equippedItem = 0;

global.spawnX = 0;
global.spawnY = 0;
global.spawnRoom = rm_entrance;
global.setPosToSpawnPos = false;

//Array containing quest structs.
global.activeQuests = array_create(0);
//Array containing all completed quest names
global.completedQuests = array_create(0);
	
global.textSpeed = 0.75;
surface_resize(application_surface, RESOLUTION_W, RESOLUTION_H);