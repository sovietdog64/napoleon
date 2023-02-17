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
global.heldItem = global.hotbarItems[global.equippedItem];

enum states {
	IDLE,
	MOVE,
	ATTACK,
	DEAD,
}

enum attackStates {
	SHOOT,
	RELOAD,
	MELEE,
	NONE,
}

enum gunTypes {
	PISTOL,
	RIFLE,
	REVOLVER,
	SHOTGUN,
	SNIPER,
}

enum itemAnimations {
	NONE,
	PUNCHING,
	GUN,
	SWORD,
	KNIFE_STAB,
	DAGGER,
}

enum biomes {
	FIELD,
}

enum structureTypes {
	ALL,
	GROUND,
	WATER,
}

enum inventories {
	NONE,
	PLAYER_INV,
	CRAFTING,
	EQUIPMENT,
}

global.drag = 0.9;
global.savingGame = false;
global.loadingGame = false;

global.noHud = false;