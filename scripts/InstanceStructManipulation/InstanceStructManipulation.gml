//This is meant to be used in obj_saveLoad only.
function structifyInstance(inst, roomStruct) {
	
	//If not instance, then throw an exception saying so.
	if(!isInstance(inst))
		throw("ERROR: this instance you are trying to structify is not an instance!");
	
	//Make sure roomStruct is a struct
	if(!is_struct(roomStruct))
		throw("ERROR: the room struct inputted is not a struct!")
	
	//if previously saved, then return its mem address only
	if(variable_struct_exists(roomStruct.instMem, string(inst))) {
		return string(inst);
	}
	
	var instArray = instance_exists(inst) ? roomStruct.instances : roomStruct.deactivatedInstances;
	
	var instStruct = {
		x : inst.x,
		y : inst.y,
	};
	
	//Setting the required built-in instance variables.
	var objName = object_get_name(inst.object_index);
	var sprName = sprite_get_name(inst.sprite_index);
	variable_struct_set(instStruct, "object_index", objName);
	if(asset_get_type(sprName) != asset_unknown)
		variable_struct_set(instStruct, "sprite_index", sprName);
	variable_struct_set(instStruct, "depth", inst.depth);
	
	variable_struct_set(instStruct, "image_xscale", inst.image_xscale)
	variable_struct_set(instStruct, "image_yscale", inst.image_yscale)
	variable_struct_set(instStruct, "image_index", inst.image_index)
	variable_struct_set(instStruct, "image_angle", inst.image_angle)
	
	
	//Get all var names to ignore for this instance
	var varsToIgnore = [];
	
	var keys = variable_struct_get_names(global.objSaveVarsIgnore);
	var key,val;
	for(var i=0; i<array_length(keys); i++) {
		var key = keys[i];
		var objIndex = asset_get_index(key);
		if(object_is_ancestor(inst.object_index, objIndex)) {
			varsToIgnore = global.objSaveVarsIgnore[$ key];
			break;
		}
	}
	
	//Saving all instance variables to the instance struct.
	var keys = variable_instance_get_names(inst);
	var key,val;
	for(var i=0; i<array_length(keys); i++) {
		key = keys[i];
		
		//if this value should be ignored when saving, then ignore it.
		if(array_contains(varsToIgnore, key))
			continue;
			
		val = variable_instance_get(inst, key);
		
		//If bool or string, just save it and continue on.
		//I didnt include is_numeric, because numbers can be interpreted in various ways in gamemaker
		if(is_bool(val) || is_string(val)) {
			variable_struct_set(instStruct, key, val);
			continue;
		}
		
		if(is_numeric(val)) {
			if(stringContains("Spr", key)) {
				val = sprite_get_name(val);
				variable_struct_set(instStruct, key, val);
				continue;
			}
			else if(stringContains("Obj", key)) {
				val = object_get_name(val);
				variable_struct_set(instStruct, key, val);
				continue;
			}
		}
		
		//function calling its self looks very goofy, but it in this case, it makes sense since the code will convert all data down to the core data types.
		if(isInstance(val)) 
			val = structifyInstance(val, roomStruct);
		
		else if(is_array(val)) 
			val = duplicateArraySave(val, roomStruct);
		
		else if(is_method(val)) {//Remove method vars, because you cannot save method vars in any way.
			variable_struct_remove(instStruct, key);
			continue;
		}
			
		else if(is_struct(val))
			val = duplicateStructSave(val, roomStruct);
		
		else if(isDsGrid(key, val))
			val = dsGridToArrSave(val, roomStruct);
			
		
		variable_struct_set(instStruct, key, val);
	}
	
	//Have to make "memory addresses" because some instances will reference other ones, and making a struct for each instance referenced will create duplicates of the same instance when loading.
	var memAddress = string(inst);
	
	//Add struct to save's memory
	variable_struct_set(roomStruct.instMem, memAddress, instStruct);
	
	array_push(instArray, memAddress);
	
	
	return memAddress;
}
	
function structWithInstanceStructsConvert(struct, parStruct_or_array, parKey_or_array_index) {
	
	//If this struct is an instance struct, then convert it into an instance.
	if(variable_struct_exists(struct, "object_index")) {
		if(is_struct(parStruct_or_array)) {
			parStruct_or_array[$ parKey_or_array_index] = structToInstance(struct);
		}
		else if(is_array(parStruct_or_array)) {
			parStruct_or_array[parKey_or_array_index] = structToInstance(struct);
		}
		else
			throw("ERROR: parStruct_or_array is neither a struct nor array!");
		
		return;
	}
	
	//If struct is an object with a defined type, then turn it into that type.
	if(variable_struct_exists(struct, "class") && is_string(struct.class) && asset_get_type(struct.class) == asset_script) {
		//Getting the constructor of the type.
		var scr = asset_get_index(struct.class);
		var newStruct = new scr();
		
		var keys = variable_struct_get_names(struct);
		var key,val;
		for(var i=0; i<array_length(keys); i++) {
			key = keys[i];
			val = struct[$ key];
			variable_struct_set(newStruct, key, val);
		}
		struct = newStruct;
		
		if(is_struct(parStruct_or_array)) 
			parStruct_or_array[$ parKey_or_array_index] = newStruct;
		
		else if(is_array(parStruct_or_array)) 
			parStruct_or_array[parKey_or_array_index] = newStruct;
		
	}
	
	//Not an instance struct? loop through all data in the struct, then turn the instance structs into instances.
	var keys = variable_struct_get_names(struct);
	var key,val;
	for(var i=0; i<array_length(keys); i++) {
		key = keys[i];
		val = struct[$ key];
		if(is_struct(val)) {
			structWithInstanceStructsConvert(val, struct, key);
		}
			
		else if(is_array(val)) {
			arrayWithInstanceStructsConvert(val);
		}
			
		
	}
	
}
	
function arrayWithInstanceStructsConvert(array) {
	for(var i=0; i<array_length(array); i++) {
		if(is_struct(array[i])) {
			structWithInstanceStructsConvert(array[i], array, i);
		}
	}
}
	
function structToInstance(struct) {
	if(!variable_struct_exists(struct, "object_index"))
		return;
		
	
	//Have to store the index in another variable to prevent crash with editing read-only variable.
	var objectIndex = asset_get_index(struct.object_index)
	variable_struct_remove(struct, "object_index");
	
	
	var keys = variable_struct_get_names(struct);
	var key, val;
	
	//Converting struct strings into asset indexes 
	for(var i=0; i<array_length(keys); i++) {
		key = keys[i];
		val = variable_struct_get(struct, key);
		if(is_string(val) && asset_get_type(val) != asset_unknown) {
			variable_struct_set(struct, key, asset_get_index(val));
		}
	}
	
	//Loop through all arrays & structs that may contain more instances, and turn them into structs as well.
	for(var i=0; i<array_length(keys); i++) {
		key = keys[i];
		val = struct[$ key];
		
		if(is_struct(val)) {
			structWithInstanceStructsConvert(val, struct, key);
		}
		else if(is_array(val)) {
			arrayWithInstanceStructsConvert(val)
		}
	}
		
	variable_struct_set(struct, "noCreateEvent", true);
		
	var inst = instance_create_depth(
		struct.x, struct.y,
		struct.depth,
		objectIndex,
		struct
	);
		
	//Making sure that instance values are the same
	with(inst) {
		for(var i=0; i<array_length(keys); i++) {
			key = keys[i];
			val = variable_struct_get(struct, key);
			if(variable_instance_get(inst, key) != val) {
				if(is_string(val) &&  asset_get_type(val) != asset_unknown) {
					variable_instance_set(inst, key, asset_get_index(val));
				}
				else
					variable_instance_set(inst, key, val);
			}
		}
	}
	
	return inst;
	
}


function duplicateArraySave(array, roomStruct) {
	
	//Prevent saving the array if it was marked as "saved" in this room struct.
	var memoryAddrs = variable_struct_get_names(roomStruct.savedMemory.savedArrays);
	var memoryAddr,val;
	for(var i=0; i<array_length(memoryAddrs); i++) {
		memoryAddr = memoryAddrs[i];
		val = roomStruct.savedMemory.savedArrays[$ memoryAddr];
		//If this array was previously saved in this room struct,
		if(val == array) {
			//Return its mem address in the save.
			return memoryAddr;
		}
	}
	
	var newArray = [];
	for(var i=0; i<array_length(array); i++) {
		var val = array[i];
		if(is_bool(val) || is_string(val)) {
			array_push(newArray, val);
			continue;
		}
		
		if(isInstance(val))
			val = structifyInstance(val, roomStruct);
			
		else if(is_array(val)) 
			val = duplicateArraySave(val, roomStruct);
			
		else if(is_method(val)) {
			continue;
		}
		
		else if(is_struct(val))
			val = duplicateStructSave(val, roomStruct);
		
		
		
		array_push(newArray, val);
	}
	
	
	var memAddr = irandom_range(0, 2147483648);
	while(variable_struct_exists(roomStruct.memory.arrays, string(memAddr) + "_array")) 
		memAddr = irandom_range(0, 2147483648);
	
	//Save array to room memory
	variable_struct_set(roomStruct.memory.arrays, string(memAddr) + "_array", newArray);
	
	//mark this array as "saved" for this room struct.
	variable_struct_set(roomStruct.savedMemory.savedArrays, string(memAddr) + "_array", array);
	
	return string(memAddr) + "_array";
}

function duplicateStructSave(struct, roomStruct) {
	
	//Prevent saving the struct if it was marked as "saved" in this room struct.
	var memoryAddrs = variable_struct_get_names(roomStruct.savedMemory.savedStructs);
	var memoryAddr,val;
	for(var i=0; i<array_length(memoryAddrs); i++) {
		memoryAddr = memoryAddrs[i];
		val = roomStruct.savedMemory.savedStructs[$ memoryAddr];
		//If this struct was previously saved in this room struct,
		if(val == struct) {
			//Return its mem address in the save.
			return memoryAddr;
		}
	}
	
	var class = instanceof(struct);
	var constructr = asset_get_index(class);
	
	var newStruct = {};
	
	if(script_exists(constructr)) {
		newStruct = new constructr();
		variable_struct_set(newStruct, "class", class);
	}
	
	var keys = variable_struct_get_names(struct);
	var key, val;
	for(var i=0; i<array_length(keys); i++) {
		key = keys[i];
		val = variable_struct_get(struct, key);
		if(is_bool(val) || is_string(val)) {
			variable_struct_set(newStruct, key, val);
			continue;
		}
		
		if(isInstance(val))
			val = structifyInstance(val, roomStruct);
			
		else if(is_array(val)) 
			val = duplicateArraySave(val, roomStruct);
			
		else if(is_method(val)) {
			variable_struct_remove(newStruct, key);
			continue;
		}
			
		else if(is_struct(val))
			val = duplicateStructSave(val, roomStruct);
		
		else if(isDsGrid(key, val))
			val = dsGridToArrSave(val, roomStruct);
		
		
		variable_struct_set(newStruct, key, val);
	}
		
		
	var memAddr = irandom_range(0, 2147483648);
	while(variable_struct_exists(roomStruct.memory.structs, string(memAddr) + "_struct")) 
		memAddr = irandom_range(0, 2147483648);
	
	variable_struct_set(roomStruct.memory.structs, string(memAddr) + "_struct", newStruct);
	
	//mark this struct as "saved" for this room struct.
	variable_struct_set(roomStruct.savedMemory.savedStructs, string(memAddr) + "_struct", struct);
	
	return string(memAddr) + "_struct";
}
	
//Works with deactivated instances
//Doesnt check if instance exists, because deactivated instances will always return false on that function.
function isInstance(inst) {
	//Has to be a numeric ID of some sort.
	if(!is_numeric(inst))
		return false;
	
	return string_pos("ref ", string(inst)) == 1;
}
	
	
function dsGridToArr(grid) {
	var arr = [[]];
	for(var r=0; r<ds_grid_width(grid); r++) {
		for(var c=0; c<ds_grid_height(grid); c++)
			arr[r][c] = grid[# c, r];
	}
	return arr;
}

function dsGridToArrSave(grid, roomStruct) {
	
	if(!is_struct(roomStruct))
		throw("ERROR: inputted roomStruct is not a struct!");
		
	//Prevent saving the grid if it was marked as "saved" in this room struct.
	var memoryAddrs = variable_struct_get_names(roomStruct.savedMemory.savedDsGrids);
	var memoryAddr,val;
	for(var i=0; i<array_length(memoryAddrs); i++) {
		memoryAddr = memoryAddrs[i];
		val = roomStruct.savedMemory.savedDsGrids[$ memoryAddr];
		//If this grid was previously saved in this room struct,
		if(val == grid) {
			//Return its mem address in the save.
			return memoryAddr;
		}
	}
	
	var arr = [[]];
	var val;
	for(var r=0; r<ds_grid_width(grid); r++) {
		for(var c=0; c<ds_grid_height(grid); c++) {
			val = grid[# c, r];
			
			if(isInstance(val)) 
				val = structifyInstance(val, roomStruct);
			
			else if(is_array(val))
				val = duplicateArraySave(val, roomStruct);
			
			else if(is_method(val))
				continue;
			
			else if(is_struct(val))
				val = duplicateStructSave(val, roomStruct);
			
				
			arr[r][c] = val;
		}
	}
	
	var memAddr = irandom_range(0, 2147483648);
	while(variable_struct_exists(roomStruct.memory.dsGrids, string(memAddr) + "_grid")) 
		memAddr = irandom_range(0, 2147483648);
		
	var memAddrName = string(memAddr) + "_grid";
	
	//Save grid to room memory
	variable_struct_set(roomStruct.memory.dsGrids, memAddrName, arr);
	
	//mark grid as "saved" for room struct
	variable_struct_set(roomStruct.savedMemory.savedDsGrids, memAddrName, grid);
	
	return memAddrName;
}
	
function isDsGrid(varName, grid) {
	if(!stringContainsNoCase(varName, "grid"))
		return false;
	try {
		var test = ds_grid_width(grid);
		return test;
	}
	catch(err) {return false;}
}

function printGrid(grid) {
	var str = "";
	for(var r=0; r<ds_grid_width(grid); r++) {
		str += "[ ";
		for(var c=0; c<ds_grid_height(grid); c++)
			str += string(grid[# c, r]) + ",";
		
		str += "\n";
	}
	show_debug_message(str);
	return str;
}

function print2DArray(arr) {
	var str = "";
	for(var r=0; r<array_length(arr); r++) {
		str += string(arr[r]) + "\n"
	}
	show_debug_message(str);
	return str;
}