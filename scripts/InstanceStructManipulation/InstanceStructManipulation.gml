#region saving

//This is meant to be used in obj_saveLoad only.
function structifyInstance(inst, roomStruct) {
	
	//If not instance, then throw an exception saying so.
	if(!isInstance(inst))
		throw("ERROR: this instance you are trying to structify is not an instance!");
	
	try {
		if(inst.object_index == obj_player) {
			return;
		}
	}
	catch(err) {return;}
	
	//Make sure roomStruct is a struct
	if(!is_struct(roomStruct))
		throw("ERROR: the room struct inputted is not a struct!")
	
	//if previously saved, then return its mem address only
	if(variable_struct_exists(roomStruct.instMem, string(inst))) {
		return string(inst);
	}
	
	var instArray = roomStruct.instances;
	
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
		if(object_is_ancestor(inst.object_index, objIndex) || inst.object_index == objIndex) {
			varsToIgnore = global.objSaveVarsIgnore[$ key];
			break;
		}
	}
	
	//Have to make "memory addresses" because some instances will reference other ones, and making a struct for each instance referenced will create duplicates of the same instance when loading.
	var memAddress = string(inst);
	
	variable_struct_set(roomStruct.instMem, memAddress, instStruct);
	
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
	
	//Get the address for the array in the save
	var memAddr = string(irandom_range(0, 2147483648)) + "_array";
	while(variable_struct_exists(roomStruct.memory.arrays, memAddr))
		memAddr = string(irandom_range(0, 2147483648)) + "_array";
	
	//Create the spot for the array before hand to prevent infinite loops
	variable_struct_set(roomStruct.memory.arrays, memAddr, newArray);
	
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
	
	
	//Save the complete array to room save's memory
	variable_struct_set(roomStruct.memory.arrays, memAddr, newArray);
	
	//mark this array as "saved" for this room struct.
	variable_struct_set(roomStruct.savedMemory.savedArrays, memAddr, array);
	
	return string(memAddr);
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


function dsGridToArrSave(grid, roomStruct, customMemAddr = undefined) {
	
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
	for(var r=0; r<ds_grid_height(grid); r++) {
		for(var c=0; c<ds_grid_width(grid); c++) {
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
	
	if(customMemAddr != undefined)
		memAddrName = customMemAddr;
	
	//Save grid to room memory
	variable_struct_set(roomStruct.memory.dsGrids, memAddrName, arr);
	
	//mark grid as "saved" for room struct
	variable_struct_set(roomStruct.savedMemory.savedDsGrids, memAddrName, grid);
	
	return memAddrName;
}

//Works with deactivated instances
//Doesnt check if instance exists, because deactivated instances will always return false on that function.
function isInstance(inst) {
	//Has to be a numeric ID of some sort.
	if(!is_numeric(inst))
		return false;
	
	return string_pos("ref ", string(inst)) == 1;
}
	
#endregion saving
	
#region loading

function loadArray(arrayKey, roomStruct, loadedStruct) {
	//if previously loaded, then return the loaded array.
	var loadedArrayAddrs = variable_struct_get_names(loadedStruct.newLoadedMemory.arrays);
	if(array_contains(loadedArrayAddrs, arrayKey)) {
		return loadedStruct.newLoadedMemory.arrays[$ arrayKey];
	}
	
	var array = roomStruct.memory.arrays[$ arrayKey];
	var newArr = [];
	
	//Adding new converted values to newArr
	for(var i=0; i<array_length(array); i++) {
		
		var val = array[i];
		
		//Converting string references into loaded data.
		if(is_string(val)) {
			if(stringContains("_array", val)) 
				val = loadArray(val, roomStruct, loadedStruct);
				
			else if(stringContains("_struct", val))
				val = loadStruct(val, roomStruct, loadedStruct);
				
			else if(stringContains("_grid", val))
				val = loadGrid(val, roomStruct, loadedStruct);
			
			else if(string_pos("ref ", val) == 1)
				val = loadInstanceStruct(val, roomStruct, loadedStruct)
			
			else {
				var assetType = asset_get_type(val);
				//Convert string into asset if it is an asset 
				//Avoid scripts. those will be saved in a variable called "class"  in a struct. such a string will be the name of a constructor.
				if(assetType != asset_unknown && assetType != asset_script) 
					val = asset_get_index(val);
			}
		}
		
		//push the value to the new loaded array after altering it.
		array_push(newArr, val);
		
	}


	//Set this array in a loaded memory struct
	loadedStruct.newLoadedMemory.arrays[$ arrayKey] = newArr;
		
	return newArr;
}
	
function loadStruct(structKey, roomStruct, loadedStruct) {
	//if previously loaded, then return the loaded struct.
	if(variable_struct_exists(loadedStruct.newLoadedMemory.structs, structKey)) {
		return loadedStruct.newLoadedMemory.structs[$ structKey];
	}
		
	var struct = roomStruct.memory.structs[$ structKey];
	var newStruct = {};
	
	if(variable_struct_exists(roomStruct.memory.structs[$ structKey], "class")) {
		var class = roomStruct.memory.structs[$ structKey].class;
		if(asset_get_type(class) != asset_unknown) {
			var constructorFunc = asset_get_index(class);
			newStruct = new constructorFunc();
		}
	}
	
	var keys = variable_struct_get_names(struct);
	var key, val;
	for(var i=0; i<array_length(keys); i++) {
		key = keys[i];
		val = struct[$ key];
		
		//Converting string references into loaded data.
		if(is_string(val)) {
			if(stringContains("_array", val)) 
				val = loadArray(val, roomStruct, loadedStruct);
				
			else if(stringContains("_struct", val))
				val = loadStruct(val, roomStruct, loadedStruct);
				
			else if(stringContains("_grid", val))
				val = loadGrid(val, roomStruct, loadedStruct);
			
			else if(string_pos("ref ", val) == 1)
				val = loadInstanceStruct(val, roomStruct, loadedStruct)
			
			else {
				var assetType = asset_get_type(val);
				//Convert string into asset if it is an asset 
				//Avoid scripts. those will be saved in a variable called "class"  in a struct. such a string will be the name of a constructor.
				if(assetType != asset_unknown && assetType != asset_script) 
					val = asset_get_index(val);
			}
		}
		
		newStruct[$ key] = val;
	}
	
	variable_struct_remove(newStruct, "class");
			
	loadedStruct.newLoadedMemory.structs[$ structKey] = newStruct;
	
	return newStruct;
}
	
function loadGrid(gridKey, roomStruct, loadedStruct) {
	//If grid was already loaded, then return its loaded version
	if(variable_struct_exists(loadedStruct.newLoadedMemory.dsGrids, gridKey)) {
		return loadedStruct.newLoadedMemory.dsGrids[$ gridKey];
	}
	
	var arr2D = roomStruct.memory.dsGrids[$ gridKey];
	
	if(!is_array(arr2D[0])) 
		throw("ERROR: Invalid grid!");
	
	var newGrid = ds_grid_create(array_length(arr2D[0]),array_length(arr2D));
	
	for(var r=0; r<ds_grid_height(newGrid); r++) {
		for(var c=0; c<ds_grid_width(newGrid); c++) {
			var val = arr2D[r][c];
			
			//Converting string references into loaded data.
			if(is_string(val)) {
				if(stringContains("_array", val)) 
					val = loadArray(val, roomStruct, loadedStruct);
				
				else if(stringContains("_struct", val))
					val = loadStruct(val, roomStruct, loadedStruct);
				
				else if(stringContains("_grid", val))
					val = loadGrid(val, roomStruct, loadedStruct);
			
				else if(string_pos("ref ", val) == 1)
					val = loadInstanceStruct(val, roomStruct, loadedStruct)
			
				else {
					var assetType = asset_get_type(val);
					//Convert string into asset if it is an asset 
					//Avoid scripts. those will be saved in a variable called "class"  in a struct. such a string will be the name of a constructor.
					if(assetType != asset_unknown && assetType != asset_script) 
						val = asset_get_index(val);
				}
			}
			
			newGrid[# c,r] = val;
		}
		
	}
	
	loadedStruct.newLoadedMemory.dsGrids[$ gridKey] = newGrid;
	
	return newGrid
}
	
function loadInstanceStruct(instKey, roomStruct, loadedStruct) {
	if(!variable_struct_exists(roomStruct.instMem[$ instKey], "object_index"))
		throw("ERROR: Invalid instance struct!");
		
	if(roomStruct.instMem[$ instKey].object_index == "obj_player") {
		return;
	}
		
	//if instance was already loaded, then return its instance ID.
	if(variable_struct_exists(loadedStruct.newLoadedInstances, instKey)) {
		return loadedStruct.newLoadedInstances[$ instKey];
	}
	
	var savedInstStruct = roomStruct.instMem[$ instKey];
	var instVarStruct = {};
		
	//Have to store the index in another variable to prevent crash with editing read-only variable.
	var objectIndex = asset_get_index(savedInstStruct.object_index);
	
	//Create dummy instance to prevent infinite loop with instances containing each-other's IDs
	instVarStruct[$ "noCreateEvent"] = true;
	
	var inst = instance_create_depth(
		0, 0,
		0,
		objectIndex,
		instVarStruct
	)
	
	loadedStruct.newLoadedInstances[$ instKey] = inst;
	
	//Getting all data for instance into the var struct.
	var keys = variable_struct_get_names(savedInstStruct);
	var key, val;
	for(var i=0; i<array_length(keys); i++) {
		key = keys[i];
		if(key == "object_index") //Skip object index to prevent editing read-only variable
			continue;
		val = savedInstStruct[$ key];
		
		//Converting string references into loaded data.
		if(is_string(val)) {
			if(stringContains("_array", val)) 
				val = loadArray(val, roomStruct, loadedStruct);
				
			else if(stringContains("_struct", val))
				val = loadStruct(val, roomStruct, loadedStruct);
				
			else if(stringContains("_grid", val))
				val = loadGrid(val, roomStruct, loadedStruct);
			
			else if(string_pos("ref ", val) == 1)
				val = loadInstanceStruct(val, roomStruct, loadedStruct)
				
			
			else {
				var assetType = asset_get_type(val);
				//Convert string into asset if it is an asset 
				//Avoid scripts. those will be saved in a variable called "class"  in a struct. such a string will be the name of a constructor.
				if(assetType != asset_unknown && assetType != asset_script) 
					val = asset_get_index(val);
			}
		}
		
		//Set value after converting it.
		instVarStruct[$ key] = val;
	}
	
	
	//Update the dummy instance's variables to contain the right information.
	with(inst) {
		keys = variable_struct_get_names(instVarStruct);
		var key,val;
		for(var i=0; i<array_length(keys); i++) {
			key = keys[i];
			val = instVarStruct[$ key];
			
			variable_instance_set(inst, key, val);
		}
	}
		
	//And save it to the loaded instances
	loadedStruct.newLoadedInstances[$ instKey] = inst;
	
	delete instVarStruct;
	
	return inst;
}
	
#endregion loading
	
#region utils

function dsGridToArr(grid) {
	var arr = [[]];
	for(var r=0; r<ds_grid_height(grid); r++) {
		for(var c=0; c<ds_grid_width(grid); c++)
			arr[r][c] = grid[# c, r];
	}
	return arr;
}

function arrToDsGrid(arr) {
	var grid = ds_grid_create(array_length(arr[0]),array_length(arr))
	for(var r=0; r<ds_grid_height(grid); r++) {
		for(var c=0; c<ds_grid_width(grid); c++) {
			grid[# c,r] = arr[r][c];
		}
	}
	
	return grid;
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
		for(var c=0; c<ds_grid_height(grid); c++)
			str += string(numRound(grid[# c, r])) + ",";
		
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
	
#endregion utils