skipRoomSave = false;

global.statData = 
{
	saveX : 0,
	saveY : 0,
	saveRm : "rm_entrance",
	
	hp : 5,
	equippedItem : -1,
	invItems : 0,
	hotbarItems : 0,
	level : 1,
	levelUpThreshold : 30,
	xp : 0,
	spawnX : 0,
	spawnY : 0,
	spawnRoom : 0,
	activeQuests : array_create(0),
	completedQuests : array_create(0),
}

global.levelData = {
	dungeons : {}
}

global.allSaveableEnemyObjects = [];//Add objects like obj_spider for example only IF you want their death to be saved. Might want to do this for bosses only.