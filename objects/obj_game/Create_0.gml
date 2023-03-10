
#region globals
global.gamePaused = false;
global.saveNum = 0;
persistent = true;

global.loadingRoom = false;
global.loadedGame = false;

global.loadedOverworld = false;
global.newWorld = false;

global.terrainGrid = ds_grid_create(1,1);

global.invItems = array_create(8, -1);
global.hotbarItems = array_create(3, -1);
global.equippedItem = 0;

global.spawnX = 0;
global.spawnY = 0;
global.spawnRoom = terrainGenTest;

//Array containing quest structs.
global.activeQuests = array_create(0);
//Array containing all completed quest names
global.completedQuests = array_create(0);
	
global.textSpeed = 0.75;
surface_resize(application_surface, RESOLUTION_W, RESOLUTION_H);
global.heldItem = global.hotbarItems[global.equippedItem];

global.drag = 0.9;

global.screenOpen = false;

global.reachDistance = TILEW*4;

global.renderDist = 24;
global.chunkLoadDelay = room_speed*0.2;

global.craftingRecipieBook = [];//Contains all unlocked recipies

global.pathfindGrid = 0;

randomize();
global.randomSeed = random_get_seed();
global.dungeonRoomAddress = "";

global.invOpen = false;

#endregion globals

global.saveGame = false;

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
	new CraftingRecipie(new WoodStick(2), [new Wood(1)], [Axe]),
	new CraftingRecipie(new Handle(2), [new WoodStick()], [Axe]),
	new CraftingRecipie(new WoodSword(), [new Wood(3), new Handle()]),
	new CraftingRecipie(new IronSword(), [new Iron(4), new Handle()]),
	new CraftingRecipie(new IronHatchet(), [new Iron(3), new WoodStick()]),
	new CraftingRecipie(new Bow(), [new String(2), new WoodStick(3)]),
]

#endregion crafting recipies

#region vars to ignore when saving

global.objSaveVarsIgnore = {
	"obj_enemy" : ["path"],
	"obj_spawner" : ["enemiesSpawned"]
}

#endregion vars to ignore when saving

#region dungeon func

global.dungeonCreationCode = function() {};

#endregion dungeon func

alarm_set(0, room_speed);

