function saveRoom2() {
	closeAllScreens();
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
		},
		
		spawnX : global.spawnX,
		spawnY : global.spawnY,
		
		playerX : obj_player.x,
		playerY : obj_player.y,
	};
	
	for(var i=0; i<instance_number(all); i++) {
		var inst = instance_find(all, i);
		if(inst.persistent || 
			inst.object_index == obj_player || 
			!isInstance(inst) ||
			object_is_ancestor(inst.object_index, obj_tilePar))
			continue;
		
		structifyInstance(inst, roomStruct);
		
	}
	
	for(var i=0; i<array_length(obj_terrainGenerator.deactivatedInstances); i++) {
		var inst = obj_terrainGenerator.deactivatedInstances[i];
		try{
			if(inst.persistent || 
				inst.object_index == obj_player || 
				!isInstance(inst) ||
				object_is_ancestor(inst.object_index, obj_tilePar))
				continue;
		} catch(err) {continue;}
		
		structifyInstance(inst, roomStruct);
	}
	
	if(room != rm_dungeon)
		variable_struct_set(global.levelData, room_get_name(room), roomStruct);
	else
		global.levelData.dungeonRooms[$ global.dungeonRoomAddress] = roomStruct;
	
	clipboard_set_text(json_stringify(global.levelData))
}
	
function loadRoom2() {
	closeAllScreens();
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
		array_push(obj_terrainGenerator.deactivatedInstances, inst);
	}
	
	for(var i=0; i<array_length(roomStruct.instances); i++) {
		var instKey = roomStruct.instances[i];
		var inst = loadInstanceStruct(instKey, roomStruct, loadedStruct);
	}
	
	instance_destroy(obj_player)
	instance_create_layer(roomStruct.playerX, roomStruct.playerY, "Instances", obj_player);
	
	delete loadedStruct;
	
	return 1;
}

function saveGame() {
	
	saveRoom2();
	
	var saveArray = [];
	
	global.statData.saveX = obj_player.x;
	global.statData.saveY = obj_player.y;
	global.statData.spawnX = global.spawnX;
	global.statData.spawnY = global.spawnY;
	global.statData.saveRm = room_get_name(room);
	if(global.dead) {
		global.statData.saveX = global.spawnX;
		global.statData.saveY = global.spawnY;
	}
	
	global.statData.hp = global.hp;
	global.statData.maxHp = global.maxHp;
	
	global.statData.invItems = [];
	for(var i=0; i<array_length(global.invItems); i++) {
		var item = global.invItems[i];
		
		var newStruct = {}
		if(isItem(item)){
			newStruct = copyStruct(item);
			newStruct.itemSpr = sprite_get_name(newStruct.itemSpr);
			newStruct.class = instanceof(item);
			array_push(global.statData.invItems, newStruct)
		}
		else
			array_push(global.statData.invItems, -1);
	}
	
	global.statData.hotbarItems = [];
	for(var i=0; i<array_length(global.hotbarItems); i++) {
		var item = global.hotbarItems[i];
		
		var newStruct = {}
		if(isItem(item)){
			newStruct = copyStruct(item);
			newStruct.itemSpr = sprite_get_name(newStruct.itemSpr);
			newStruct.class = instanceof(item);
			array_push(global.statData.hotbarItems, newStruct)
		}
		else
			array_push(global.statData.hotbarItems, -1);
	}
		
	global.statData.level = global.level;
	global.statData.levelUpThreshold = global.levelUpThreshold;
	global.statData.xp = global.xp;

	global.statData.dungeonRoomAddress = global.dungeonRoomAddress;
	
	
	array_push(saveArray, global.statData);
	array_push(saveArray, global.levelData);
	
	var fileName = "saveData" + string(global.saveNum) + ".sav";
	var json = json_stringify(saveArray);
	var buf = buffer_create(string_byte_length(json)+1, buffer_fixed, 1);
	buffer_write(buf, buffer_string, json);
	buffer_save(buf, fileName);
	buffer_delete(buf);
}

function loadGame() {
	var fileName = "saveData" + string(global.saveNum) + ".sav";
	if(!file_exists(fileName))
		return;
	
	var buf = buffer_load(fileName);
	var json = buffer_read(buf, buffer_string);
	buffer_delete(buf);
	
	var loadArr = json_parse(json);
	
	global.statData = array_get(loadArr, 0);
	global.levelData = array_get(loadArr, 1);
	
	if(!room_exists(asset_get_index(global.statData.saveRm)))
		return 1;
	
	obj_player.x = global.statData.saveX;
	obj_player.y = global.statData.saveY;
	global.spawnX = global.statData.spawnX;
	global.spawnY = global.statData.spawnY;
	
	global.hp = global.statData.hp;
	global.maxHp = global.statData.maxHp;
	
	global.invItems = [];
	for(var i=0; i<array_length(global.statData.invItems); i++) {
		var item = global.statData.invItems[i];
		
		var newStruct = {}
		if(isItem(item)) {
			if(variable_struct_exists(item, "class")) {
				var func = asset_get_index(item.class);
				newStruct = new func();
				
				var keys = variable_struct_get_names(item);
				var key,val;
				for(var j=0; j<array_length(keys); j++) {
					key = keys[j];
					val = item[$ key];
					if(key == "itemSpr")
						val = asset_get_index(val);
					variable_struct_set(newStruct, key, val);
				}
				
				array_push(global.invItems, newStruct);
			}
		}
		else
			array_push(global.invItems, -1)
	}
		
	global.hotbarItems = [];
	for(var i=0; i<array_length(global.statData.hotbarItems); i++) {
		var item = global.statData.hotbarItems[i];
		
		var newStruct = {}
		if(isItem(item)) {
			if(variable_struct_exists(item, "class")) {
				var func = asset_get_index(item.class);
				newStruct = new func();
				
				var keys = variable_struct_get_names(item);
				var key,val;
				for(var j=0; j<array_length(keys); j++) {
					key = keys[j];
					val = item[$ key];
					if(key == "itemSpr")
						val = asset_get_index(val);
					variable_struct_set(newStruct, key, val);
				}
				
				array_push(global.hotbarItems, newStruct);
			}
		}
		else
			array_push(global.hotbarItems, -1)
	}
	
	global.level = global.statData.level;
	global.levelUpThreshold = global.statData.levelUpThreshold;
	global.xp = global.statData.xp;
	
	global.dungeonRoomAddress = global.statData.dungeonRoomAddress;
	
	var loadRm = asset_get_index(global.statData.saveRm);
	room_goto(loadRm);
	obj_player.x = global.statData.saveX;
	obj_player.y = global.statData.saveY;
	
	obj_saveLoad.skipRoomSave = true;
}