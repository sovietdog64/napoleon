function saveRoom() {
	//Get amount of saveable objects in room
	
	var roomStruct =
	{
		items : array_create(0),
		enemies : array_create(0),
		chests : array_create(0),
		ships : array_create(0),
		NPCs : array_create(0),
		playerX : 0,
		playerY : 0,
		spawnX : 0,
		spawnY : 0,
	}
	roomStruct.spawnX = global.spawnX;
	roomStruct.spawnY = global.spawnY;
	
	//Player
	if(instance_exists(obj_player)) {
		roomStruct.playerX = obj_player.x;
		roomStruct.playerY = obj_player.y;
	}
	
	//Get data from all saveable objects
	
	//NPCs
	for(var i=0; i<instance_number(obj_npc); i++) {
		var npc = instance_find(obj_npc, i);
		if(!npc.saveNPC)
			continue;
		var npcStruct = 
		{
			x : npc.x,
			y : npc.y,
			sprite_index : npc.sprite_index,
			objInd : 0,
		};
		npcStruct.objInd = object_get_name(npc.object_index);
		show_debug_message(npcStruct.objInd);
		//Names of all npc variables
		var varNames = variable_instance_get_names(npc);
		//Add object index to struct
		//Loop through all variables in NPC instance & add them to struct
		for(var j=0; j<array_length(varNames); j++) {
			var varValue = variable_instance_get(npc, varNames[j]);
			//Cannot save methods :/ (which is why it is necessary to specify the npc object index)
			if(!is_method(varValue)) {
				variable_struct_set(npcStruct, varNames[j], varValue);
			}
		}
		array_push(roomStruct.NPCs, npcStruct);
	}
	
	//Dropped Items
	for(var i=0; i<instance_number(obj_item); i++) {
		var itemInst = instance_find(obj_item, i);
		var tempStruct = {};
		if(!isItem(itemInst.item))
			continue;
		var instItemStruct = copyStruct(itemInst.item);
		{//Loop through all item struct vars and add to temp struct (doing this because some variables in item structs include assets of varying types)
		    var key, value;
		    var keys = variable_struct_get_names(instItemStruct);
		    for (var j = array_length(keys)-1; j >= 0; --j) {
		        key = keys[j];
		        value = variable_struct_get(instItemStruct, key);
				if(string_last_pos("Spr", key)) {
					value = sprite_get_name(value);
				}
				else if(string_last_pos("Seq", key)) {
					value = sequenceGetName(value);
				}
				//TODO: may add more asset types if necessary
		        variable_struct_set(tempStruct, key, value)
		    }
		}
		var itemStruct = 
		{
			x : itemInst.x,
			y : itemInst.y,
			hsp : itemInst.hsp,
			vsp : itemInst.vsp,
			pickedUp : itemInst.pickedUp,
			canBePickedUp : itemInst.canBePickedUp,
			pickUpCoolDown : itemInst.pickUpCoolDown,
			item : tempStruct,
		}
		array_push(roomStruct.items, itemStruct);
	}
	
	//Ships
	for(var i=0; i<instance_number(obj_ship); i++)  {
		var ship = instance_find(obj_ship, i);
		var shipStruct =
		{
			x : ship.x,
			y : ship.y,
			hasSetSpawnPoint : ship.hasSetSpawnPoint,
		}
		array_push(roomStruct.ships, shipStruct);
	}
	
	//Enemies (ones that should be saved.)
	for(var i=0; i<array_length(global.allSaveableEnemyObjects); i++) {
		var enemyNum = instance_number(global.allSaveableEnemyObjects[i]);
		var enemyObjInstances = array_create(0);
		//Adding all instances of enemy obj to a temp variable
		for(var j=0; j<enemyNum; j++) {
			var enemy = instance_find(global.allSaveableEnemyObjects[i], j);
			var enemyStruct = 
			{
				x : enemy.x,
				y : enemy.y,
				hp : enemy.hp,
				maxHp : enemy.maxHp,
				hsp : enemy.hsp,
				vsp : enemy.vsp,
				hspWalk : enemy.hspWalk,
				vspJump : enemy.vspJump,
				drops : enemy.drops,
				xpDrop : xpDrop,
			}
			array_push(enemyObjInstances, enemyStruct);
		}
		//Add the whole array of enemy object instances into one index of array of enemies in the room.
		array_push(roomStruct.enemies, enemyObjInstances);
	}
	
	//Chests
	for(var i=0; i<instance_number(obj_chest); i++) {
		var chest = instance_find(obj_chest, i);
		var itemArray = array_create(0);
		
		for(var j=0; j<array_length(chest.items); j++) {//Loop through all items and stores them in an array
			var tempStruct = {};
			if(!isItem(chest.items[j]))
				continue;
			var itemStruct = copyStruct(chest.items[j]);
			{//Loop through all item struct vars and add to temp struct (doing this because some variables in item structs include assets of varying types)
			    var key, value;
			    var keys = variable_struct_get_names(itemStruct);
			    for (var l = array_length(keys)-1; l >= 0; --l) {
			        key = keys[l];
			        value = variable_struct_get(itemStruct, key);
					if(string_last_pos("Spr", key)) {
						value = sprite_get_name(value);
					}
					else if(string_last_pos("Seq", key)) {
						value = sequenceGetName(value);
					}
					//TODO: may add more asset types if necessary
			        variable_struct_set(tempStruct, key, value)
			    }
			}
			array_push(itemArray, tempStruct);
		}
		var chestStruct = 
		{
			x : chest.x,
			y : chest.y,
			items : itemArray,
			opened : chest.opened,
		}
		array_push(roomStruct.chests, chestStruct);
	}
	
	//Store room struct in global.levelData
	variable_struct_set(global.levelData, room_get_name(room), roomStruct);
}
	
function loadRoom() {
	var roomStruct = 0;
	if(!variable_struct_exists(global.levelData, room_get_name(room)))
		return;
	roomStruct = variable_struct_get(global.levelData, room_get_name(room));
		
	//Cancel if roomStruct is not a struct
	if(!is_struct(roomStruct)) return;
	
	global.spawnX = roomStruct.spawnX;
	global.spawnY = roomStruct.spawnY;
	
	//Player
	if(instance_exists(obj_player)) {
		obj_player.x = roomStruct.playerX;
		obj_player.y = roomStruct.playerY;
	}
	
	//Camera
	if(instance_exists(obj_camera)) {
		obj_camera.targX = roomStruct.playerX;
		obj_camera.targY = roomStruct.playerY;
	}
	
	//Get rid of all saveable instances and replace them with the ones in the game save.
	//Items
	if(instance_exists(obj_item))
		instance_destroy(obj_item);
		
	for(var i=0; i<array_length(roomStruct.items); i++) {
		var savedItem = roomStruct.items[i];
		//Putting item values into temp struct (converts variable asset names into usable asset indexes)
		var tempStruct = {};
		//Copy struct just to make sure that none of the original content is being altered (i dont know if it will get altered, but im not gonna risk it)
		var instItemStruct = copyStruct(savedItem.item);
		var key, value;
		var keys = variable_struct_get_names(instItemStruct);
		for (var j = array_length(keys)-1; j >= 0; --j) {
			key = keys[j];
			value = variable_struct_get(instItemStruct, key);
			//If the value of current variable the loop is checking is a string, and it is an asset, then set the value to be 
			if(is_string(value)) {
				if(asset_get_type(value) != asset_unknown) {
					value = asset_get_index(value);
				}
			}
			variable_struct_set(tempStruct, key, value);
		}
		
		var inst = instance_create_layer(savedItem.x, savedItem.y, "Instances", obj_item);
		inst.x = savedItem.x;
		inst.y = savedItem.y;
		inst.hsp = savedItem.hsp;
		inst.vsp = savedItem.vsp;
		inst.pickedUp = savedItem.pickedUp;
		inst.canBePickedUp = savedItem.canBePickedUp;
		inst.pickUpCoolDown = savedItem.pickUpCoolDown;
		inst.item = tempStruct;
	}
	
	//Ships
	if(instance_exists(obj_ship))
		instance_destroy(obj_ship);
	
	for(var i=0; i<array_length(roomStruct.ships); i++) {
		var savedShip = roomStruct.ships[i];
		var inst = instance_create_layer(savedShip.x, savedShip.y, "Instances", obj_ship);
		inst.x = savedShip.x;
		inst.y = savedShip.y;
		inst.hasSetSpawnPoint = savedShip.hasSetSpawnPoint;
	}
	
	//Chests
	if(instance_exists(obj_chest))
		instance_destroy(obj_chest);
		
	for(var i=0; i<array_length(roomStruct.chests); i++) {
		var savedChest = roomStruct.chests[i];
		var itemArray = array_create(0);
		//Loop through all items and store them in itemArray
		for(var l=0; l<array_length(savedChest.items); l++) {
			var savedItem = savedChest.items[l];
			//Putting item values into temp struct (converts variable asset names into usable asset indexes)
			var tempStruct = {};
			//Copy struct just to make sure that none of the original content is being altered (i dont know if it will get altered, but im not gonna risk it)
			var instItemStruct = copyStruct(savedItem);
			var key, value;
			var keys = variable_struct_get_names(instItemStruct);
			for (var j = array_length(keys)-1; j >= 0; --j) {
				key = keys[j];
				value = variable_struct_get(instItemStruct, key);
				//If the value of current variable the loop is checking is a string, and it is an asset, then set the value to be 
				if(is_string(value)) {
					if(asset_get_type(value) != asset_unknown) {
						value = asset_get_index(value);
					}
				}
				variable_struct_set(tempStruct, key, value);
			}
			array_push(itemArray, tempStruct);
		}
		
		var inst = instance_create_layer(savedChest.x, savedChest.y, "Interactables", obj_chest, savedChest);
		inst.x = savedChest.x;
		inst.y = savedChest.y;
		inst.items = itemArray;
		inst.opened = savedChest.opened;
	}
		
	//Enemies
	for(var i=0; i<array_length(global.allSaveableEnemyObjects); i++) {
		if(instance_exists(global.allSaveableEnemyObjects[i]))
			instance_destroy(global.allSaveableEnemyObjects[i]);
		for(var j=0; j<array_length(roomStruct.enemies); j++) {
			var savedEnemy = roomStruct.enemies[i][j];
			var inst = instance_create_layer(savedEnemy.x, savedEnemy.y, "Enemies", global.allSaveableEnemyObjects[i], savedEnemy);
			inst.x = savedEnemy.x;
			inst.y = savedEnemy.y;
			inst.hp = savedEnemy.hp;
			inst.maxHp = savedEnemy.maxHp;
			inst.hsp = savedEnemy.hsp;
			inst.vsp = savedEnemy.vsp;
			inst.hspWalk = savedEnemy.hspWalk;
			inst.vspJump = savedEnemy.vspJump;
			inst.drops = savedEnemy.drops;
			inst.xpDrop = xpDrop;
		}
	}
	
	//NPCs
	//Destroy all saveable npcs 
	for(var i=0; i<instance_number(obj_npc); i++) {
		var npc = instance_find(obj_npc, i);
		if(npc.saveNPC)
			instance_destroy(npc);
	}
	//Adding saveable NPCs that are in game save
	for(var i=0; i<array_length(roomStruct.NPCs); i++) {
		var savedNpc = roomStruct.NPCs[i];
		if(variable_struct_exists(savedNpc, "disappear") && savedNpc.disappear)
			continue;
		var varNames = variable_struct_get_names(savedNpc);
		//Create NPC instance with sepcified object type
		var objectIndex = asset_get_index(savedNpc.objInd);
		var inst = instance_create_layer(savedNpc.x, savedNpc.y, "Interactables", objectIndex);
		inst.sprite_index = savedNpc.sprite_index;
		//Loop through all saved vars and add them to new NPC instance
		for(var j=0; j<array_length(varNames); j++) {
			var value = variable_struct_get(savedNpc, varNames[j]);
			variable_instance_set(inst, varNames[j], value);
		}
	}
	
	if(instance_exists(obj_player)) instance_destroy(obj_player);
	instance_create_layer(roomStruct.playerX, roomStruct.playerY, "Instances", obj_player);
}

//Saving game to file
function saveGame(fileNum = 0) {
	var saveArray = array_create(0);
	
	//Save current room
	saveRoom();
	
	//Set & Save stats
	global.statData.saveX = obj_player.x;
	global.statData.saveY = obj_player.y;
	global.statData.spawnX = global.spawnX;
	global.statData.spawnY = global.spawnY;
	global.statData.spawnRoom = room_get_name(global.spawnRoom);
	global.statData.saveRm = room_get_name(room);
	
	if(global.dead) {
		global.statData.saveX = global.spawnX;
		global.statData.saveY = global.spawnY;
		global.statData.saveRm = global.spawnRoom;
	}
	
	global.statData.hp = global.hp;
	global.statData.equippedItem = global.equippedItem;
	//Have to save name of items, because gamemaker is dum with item indexes
	//Inventory
	var tempArray = array_create(0);
	for(var i=0; i<array_length(global.invItems); i++) {
		if(!isItem(global.invItems[i])) {
			array_push(tempArray, -1);
			continue;
		}
		var tempStruct = {};
		var itemStruct = copyStruct(global.invItems[i]);
		{//Loop through all item struct vars and add to temp struct (doing this because some variables in item structs include assets of varying types)
		    var key, value;
		    var keys = variable_struct_get_names(itemStruct);
		    for (var j = array_length(keys)-1; j >= 0; --j) {
		        key = keys[j];
		        value = variable_struct_get(itemStruct, key);
				if(string_last_pos("Spr", key)) {
					value = sprite_get_name(value);
				}
				else if(string_last_pos("Seq", key)) {
					value = sequenceGetName(value);
				}
				//TODO: may add more asset types if necessary
		        variable_struct_set(tempStruct, key, value)
		    }
		}
		array_push(tempArray, tempStruct);
	}
	global.statData.invItems = tempArray;
	//Hotbar items
	tempArray = array_create(0);
	for(var i=0; i<array_length(global.hotbarItems); i++) {
		if(!isItem(global.hotbarItems[i])) {
			array_push(tempArray, -1);
			continue;
		}
		var tempStruct = {};
		var itemStruct = copyStruct(global.hotbarItems[i]);
		{//Loop through all item struct vars and add to temp struct (doing this because some variables in item structs include assets of varying types)
		    var key, value;
		    var keys = variable_struct_get_names(itemStruct);
		    for (var j = array_length(keys)-1; j >= 0; --j) {
		        key = keys[j];
		        value = variable_struct_get(itemStruct, key);
				if(string_last_pos("Spr", key)) {
					value = sprite_get_name(value);
				}
				else if(string_last_pos("Seq", key)) {
					value = sequenceGetName(value);
				}
				//TODO: may add more asset types if necessary
		        variable_struct_set(tempStruct, key, value)
		    }
		}
		array_push(tempArray, tempStruct);
	}
	global.statData.hotbarItems = tempArray;
	global.statData.level = global.level;
	global.statData.levelUpThreshold = global.levelUpThreshold;
	global.statData.xp = global.xp;
	
	global.statData.activeQuests = global.activeQuests;
	global.statData.completedQuests = global.completedQuests;
	array_push(saveArray, global.statData);
	
	//Save all room data
	array_push(saveArray, global.levelData);
	
	//The real stuff (saving to a file)
	var fileName = "saveData" + string(fileNum) + ".sav";
	var json = json_stringify(saveArray);
	var buf = buffer_create(string_byte_length(json) + 1, buffer_fixed, 1);
	buffer_write(buf, buffer_string, json);
	buffer_save(buf, fileName);
	buffer_delete(buf);
}

//Loading game from file
function loadGame(fileNum = 0) {
	//Load saved data
	var fileName = "saveData" + string(fileNum) + ".sav";
	if(!file_exists(fileName)) return;
	
	//Load buffer, get json, delete buf from memory to free memory
	var buf = buffer_load(fileName);
	var json = buffer_read(buf, buffer_string);
	buffer_delete(buf);
	
	//Turn string into usable data.
	var loadArray = json_parse(json);
	
	//Load the game save
	global.statData = array_get(loadArray, 0);
	global.levelData = array_get(loadArray, 1);
	
	//Load Stats
	//If saved room does not exist, return -1
	if(!room_exists(asset_get_index(global.statData.saveRm)))
		return -1;
	global.hp = global.statData.hp;
	global.equippedItem = global.statData.equippedItem;
	//Inventory
	var tempArray = array_create(0);
	for(var i=0; i<array_length(global.statData.invItems); i++) {
		var savedItem = global.statData.invItems[i];
		//Putting item values into temp struct (converts variable asset names into usable asset indexes)
		var tempStruct = {};
		//Copy struct just to make sure that none of the original content is being altered (i dont know if it will get altered, but im not gonna risk it)
		var itemStruct = copyStruct(savedItem);
		var key, value;
		var keys = variable_struct_get_names(itemStruct);
		for (var j = array_length(keys)-1; j >= 0; --j) {
			key = keys[j];
			value = variable_struct_get(itemStruct, key);
			//If the value of current variable the loop is checking is a string, and it is an asset, then set the value to be 
			if(is_string(value)) {
				if(asset_get_type(value) != asset_unknown) {
					value = asset_get_index(value);
				}
			}
			variable_struct_set(tempStruct, key, value);
		}
		array_push(tempArray, tempStruct);
	}
	global.invItems = tempArray;
	//Hotbar items
	tempArray = array_create(0);
	for(var i=0; i<array_length(global.statData.hotbarItems); i++) {
		var savedItem = global.statData.hotbarItems[i];
		//Putting item values into temp struct (converts variable asset names into usable asset indexes)
		var tempStruct = {};
		//Copy struct just to make sure that none of the original content is being altered (i dont know if it will get altered, but im not gonna risk it)
		var itemStruct = copyStruct(savedItem);
		var key, value;
		var keys = variable_struct_get_names(itemStruct);
		for (var j = array_length(keys)-1; j >= 0; --j) {
			key = keys[j];
			value = variable_struct_get(itemStruct, key);
			//If the value of current variable the loop is checking is a string, and it is an asset, then set the value to be 
			if(is_string(value)) {
				if(asset_get_type(value) != asset_unknown) {
					value = asset_get_index(value);
				}
			}
			variable_struct_set(tempStruct, key, value);
		}
		array_push(tempArray, tempStruct);
	}
	global.hotbarItems = tempArray;
	global.level = global.statData.level;
	global.levelUpThreshold = global.statData.levelUpThreshold;
	global.xp = global.statData.xp;
	
	global.spawnX = global.statData.spawnX;
	global.spawnY = global.statData.spawnY;
	global.spawnRoom = asset_get_index(global.statData.spawnRoom);
	
	global.activeQuests = global.statData.activeQuests;
	global.completedQuests = global.statData.completedQuests;
	
	//Go to the right room in the game save
	var loadRm = asset_get_index(global.statData.spawnRoom);
	global.loadedGame = true;
	room_goto(loadRm);
	obj_player.x = global.statData.spawnX;
	obj_player.y = global.statData.spawnY;
	//Make sure save object does not save the room that is being exited
	obj_saveLoad.skipRoomSave = true;
	if(instance_exists(obj_player)) instance_destroy(obj_player);
	instance_create_layer(global.statData.saveX, global.statData.saveY, "Instances", obj_player);
	
	loadRoom();
}