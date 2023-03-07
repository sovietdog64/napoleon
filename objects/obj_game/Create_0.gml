#region globals
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

global.gold = 0;

//Array containing quest structs.
global.activeQuests = array_create(0);
//Array containing all completed quest names
global.completedQuests = array_create(0);
	
global.textSpeed = 0.75;
surface_resize(application_surface, RESOLUTION_W, RESOLUTION_H);
global.heldItem = global.hotbarItems[global.equippedItem];

global.drag = 0.9;
global.savingGame = false;
global.loadingGame = false;

global.screenOpen = false;

global.canPlaceItem = false;
global.reachDistance = TILEW*4;

global.renderDist = 20;

global.pathfindGrid = 0;

randomize();
global.randomSeed = random_get_seed();

#endregion globals

#region enums

enum states {
	IDLE,
	MOVE,
	ATTACK,
	ATTACKED,
	DEAD,
	HURT,
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
	
enum dungRoomTypes {
	NONE,
	ENEMY,
	MERCHANT,
	SPECIAL,
	CHEST
}

#endregion enums

#region crafting recipies

global.craftingRecipies = 
[
	new CraftingRecipie(new WoodShaft(2), [new Wood(1)], [Axe]),
	new CraftingRecipie(new Handle(2), [new WoodShaft()], [Axe]),
	new CraftingRecipie(new WoodSword(), [new Wood(3), new Handle()])
]

#endregion crafting recipies

#region vars to ignore when saving

global.objSaveVarsIgnore = {
	"obj_enemy" : ["path"]
}

#endregion vars to ignore when saving

#region dungeon func

global.dungeonCreationCode = function() {};

#endregion dungeon func