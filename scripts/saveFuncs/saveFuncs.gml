function saveRoom2() {
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
		try{
			if(!isInstance(inst) || inst.persistent || inst.object_index == obj_player)
				continue;
		} catch(err) {continue;}
		
		structifyInstance(inst, roomStruct);
	}
	
	if(room != rm_dungeon)
		variable_struct_set(global.levelData, room_get_name(room), roomStruct);
	else
		global.levelData.dungeonRooms[$ global.dungeonRoomAddress] = roomStruct;
}
	
function loadRoom2() {
	if(room != rm_dungeon)
		if(!variable_struct_exists(global.levelData, room_get_name(room)))
			return 0;
	
	var roomStruct = room == rm_dungeon ? 
		global.levelData.dungeonRooms[$ global.dungeonRoomAddress] : global.levelData[$ room_get_name(room)];
	
	if(roomStruct == undefined || !variable_struct_exists(roomStruct, "memory"))
		return 0;
	
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
	
	return 1;
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
	

	
