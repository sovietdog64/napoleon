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
		if(global.savingGame) {
			roomStruct.playerX = obj_player.enteredX;
			roomStruct.playerY = obj_player.enteredY;
		}
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
				var assetName = getVarAssetName(key, value);
				if(assetName != 0)
					value = assetName;
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
	
	//Enemies (ones that should be saved.)
	for(var i=0; i<instance_number(obj_enemy); i++) {
		var enemy = instance_find(obj_enemy, i);
		if(!variable_instance_exists(enemy, "shouldSave") || !enemy.shouldSave)
			continue;
		if(!variable_instance_exists(enemy, "saveVars") || !enemy.saveVars)
			continue;
		//Store all instance variables in struct
		var struct = {};
		var keys = variable_instance_get_names(enemy);
		for(var j=0; j<array_length(keys); j++) {
			var key = keys[j], value = variable_instance_get(enemy, key);
			var assetName = getVarAssetName(key, value);
			if(assetName != 0)
				value = assetName;
			variable_struct_set(struct, key, value);
		}
		variable_struct_set(struct, "x", enemy.x);
		variable_struct_set(struct, "y", enemy.y);
		variable_struct_set(struct, "objIndex", object_get_name(enemy.object_index));
		//Add enemy to room save
		array_push(roomStruct.enemies, struct);
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
					var assetName = getVarAssetName(key, value);
					if(assetName != 0)
						value = assetName;
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
	
function saveRoom2(roomIndex = room) {
	var roomStruct = {
		instances : [],
		deactivatedInstances : [],
		instMem : {}, //This is the struct containing all inst structs. The other two arrays will reference these structs.
		memory : {
			arrays : {},
			dsGrids : {},
			dsLists : {},
			structs : {},
		},
		savedMemory : {//This struct contains all structs saved and their reference in the save file.
			savedArrays : {},
			savedDsGrids : {},
			savedDsLists : {},
			savedStructs : {},
		}
	};
	
	for(var i=0; i<instance_number(all); i++) {
		var inst = instance_find(all, i);
		if(inst.persistent || inst.object_index == obj_player || !isInstance(inst))
			continue;
		
		structifyInstance(inst, roomStruct);
		
	}
	
	for(var i=0; i<array_length(obj_terrainGenerator.deactivatedInstances); i++) {
		var inst = obj_terrainGenerator.deactivatedInstances[i];
		if(inst.persistent || inst.object_index == obj_player || !isInstance(inst))
			continue;
		
		structifyInstance(inst, roomStruct);
	}
	
	if(roomIndex != rm_dungeon)
		global.levelData[$ room_get_name(roomIndex)] = roomStruct;
	else {
		global.levelData.dungeons[$ global.dungeonRoomAddr] = roomStruct;
	}
}
	
function loadRoom2(roomIndex = room) {
	var roomStruct = global.levelData[$ room_get_name(roomIndex)];
	if(roomIndex == rm_dungeon)
		roomStruct = global.levelData.dungeons[$ global.dungeonRoomAddr];
	
	with(all) {
		if(!persistent && object_index != obj_player) {
			instance_destroy();
		}
	}
	
	var loadedStruct = {
	    newLoadedMemory : {
	        arrays : {},
	        dsGrids : {},
	        dsLists : {},
	        structs : {},
	    },
		
		newLoadedInstances : {},
	}
	
	var arrayAddrs = variable_struct_get_names(roomStruct.memory.arrays);
	for(var i=0; i<array_length(arrayAddrs); i++) {
		loadArray(arrayAddrs[i], roomStruct, loadedStruct);
	}
	
	var structAddrs = variable_struct_get_names(roomStruct.memory.structs);
	for(var i=0; i<array_length(structAddrs); i++) {
		loadStruct(structAddrs[i], roomStruct, loadedStruct);
	}
	
	var gridAddrs = variable_struct_get_names(roomStruct.memory.dsGrids);
	for(var i=0; i<array_length(gridAddrs); i++) {
		loadGrid(gridAddrs[i], roomStruct, loadedStruct);
	}
	
	for(var i=0; i<array_length(roomStruct.deactivatedInstances); i++) {
		var instKey = roomStruct.deactivatedInstances[i];
		var inst = loadInstanceStruct(instKey, roomStruct, loadedStruct);
		instance_deactivate_object(inst);
	}
	
	for(var i=0; i<array_length(roomStruct.instances); i++) {
		var instKey = roomStruct.instances[i];
		var inst = loadInstanceStruct(instKey, roomStruct, loadedStruct);
	}
	
	
	
	delete loadedStruct;
}

	
function loadRoom223456() {
	var roomStruct = variable_struct_get(global.levelData, room_get_name(room));
	var instances = roomStruct.instances;
	

	
	for(var i=0; i<array_length(instances); i++) {
		var memAddr = instances[i];
		var instStruct = roomStruct.instMem[$ memAddr];
		var inst = structToInstance(instStruct);
	}
	
	for(var i=0; i<array_length(roomStruct.deactivatedInstances); i++) {
		var memAddr = roomStruct.deactivatedInstances[i];
		var instStruct = roomStruct.instMem[$ memAddr];
		var inst = structToInstance(instStruct);
		instance_deactivate_object(inst);
	}
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
	
	var updateCameraTarg = false;
	
	//Player
	if(instance_exists(obj_player)) {
		obj_player.x = roomStruct.playerX;
		obj_player.y = roomStruct.playerY;
		if(global.setPosToSpawnPos || global.loadingGame){
			obj_player.x = global.spawnX;
			obj_player.y = global.spawnY;
			global.setPosToSpawnPos = false;
			updateCameraTarg = true;
		}
	}
	
	//Camera
	if(instance_exists(obj_camera)) {
		obj_camera.targX = roomStruct.playerX;
		obj_camera.targY = roomStruct.playerY;
		if(updateCameraTarg){
			obj_camera.targX = global.spawnX;
			obj_camera.targY = global.spawnY;
		}
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
	for(var i=0; i<instance_number(obj_enemy); i++) {
		var enemy = instance_find(obj_enemy, i);
		if(!variable_instance_exists(enemy, "shouldSave") || !enemy.shouldSave)
			continue;
		instance_destroy(enemy);
	}
		
	for(var i=0; i<array_length(roomStruct.enemies); i++) {
		var saved = roomStruct.enemies[i];
		var inst = instance_create_layer(saved.x, saved.y, "Enemies", asset_get_index(saved.objIndex));
		instSetVars(inst, saved);
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
	
}

//Saving game to file
function saveGame(fileNum = 0) {
	global.savingGame = true;
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
				if(is_numeric(value)) {
					var assetName = getVarAssetName(key, value);
					if(assetName != 0)
						value = assetName;
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
				if(is_numeric(value)) {
					var assetName = getVarAssetName(key, value);
					if(assetName != 0)
						value = assetName;
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
	global.savingGame = false;
}

//Loading game from file
function loadGame(fileNum = 0) {
	global.loadingGame = true;
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
	if(!room_exists(asset_get_index(global.statData.saveRm))) {
		show_debug_message("save room not exist: " + string(global.statData.saveRm));
		return -1;
	}
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
	global.setPosToSpawnPos = true;
	room_goto(loadRm);
	obj_player.x = global.statData.spawnX;
	obj_player.y = global.statData.spawnY;
	//Make sure save object does not save the room that is being exited
	obj_saveLoad.skipRoomSave = true;
	
	global.loadingGame = false;
}
	

	
