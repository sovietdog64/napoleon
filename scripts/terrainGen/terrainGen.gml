function cellular_automata_map(_width, _height, _spawnChance, _createLimit, _destroyLimit) constructor {
	width = _width;
	height = _height;
	spawnChance = _spawnChance;
	createLimit = _createLimit;
	destroyLimit = _destroyLimit;
	
	map = [[]];
	
	//Create & randomize map
	for(var col = width-1; col >= 0; col--) {
		for(var row = height-1; row >= 0; row--) {
			map[col][row] = random(1) <= spawnChance;
		}
	}

	static iterate = function(_num) {
		repeat(_num) {
			//Create new map to not overwrite data 
			var newMap = [];

			//Loop through old map and create a new map that includes the newly generated "chunks"
			for(var col = 0; col < width; col++) {
				for(var row = 0; row < height; row++) {
					//count of neighboring chunks
					var colDif, rowDif, count = 0;
					for(var colOffset = -1; colOffset < 2; colOffset++) {
						for(var rowOffset = -1; rowOffset < 2; rowOffset++) {
							colDif = col + colOffset;
							rowDif = row + rowOffset;
							if(colDif < 0 || rowDif < 0 || colDif >= width || rowDif >= height) {
								count++;
							} else if(colDif == 0 && rowDif == 0) {
								continue;
							} else if(map[colDif][rowDif]) {
								count++;
							}
						}
					}

					//apply rules for changing
					if(map[col][row]) {
						newMap[col][row] = count > destroyLimit;
					} else {
						newMap[col][row] = count > createLimit;
					}
				}
			}

			//replace old map with new one
			map = newMap;
		}
	}
}

//@function diamondSquare
//@param _dsGridId The id of the ds_grid that you made
//@param _height The values that the map will contain, up to said height. These values will be used to determine what goes into what tile
//@param _defaultVal The default value that should be placed in a cell of the grid. (Ex. num representing grass in a plains biome)
//@param [seed] optional seed used for generating the land.
//Returns seed generated.
//Having a grid that doesn't have square-like dimensions will terminate the function
function diamondSquare(_dsGridId, _height, _defaultVal, seed = undefined) {
	var size,sideLength,halfSide,avg,baseHeight;
	
	if(seed != undefined)
		random_set_seed(seed)
	else
		randomize();
	
	if(ds_grid_height(_dsGridId) != ds_grid_width(_dsGridId)){
	    show_debug_message("ERROR! Check if the ds_grid _height is equal to its width.");
	    return "ERROR";
	}
	size = ds_grid_height(_dsGridId);
	if(size < 2){
	    show_debug_message("ERROR! Invalid ds_grid size.");
	    return "ERROR";
	}
	if(size mod 2 == 0){
	    show_debug_message("WARNING: Size inappropriate. Increased by 1...");
	    size += 1;
	}
	
	ds_grid_clear(_dsGridId,0);
	baseHeight = _height;
	
	//Setting four corners
	_dsGridId[# 0,0] = _defaultVal;
	_dsGridId[# 0,size-1] = _defaultVal;
	_dsGridId[# size-1,0] = _defaultVal;
	_dsGridId[# size-1,size-1] = _defaultVal;
	
	sideLength = size-1;
	while(sideLength >= 2){
	    sideLength /=2
	    _height/= 2.0;

	    halfSide = sideLength/2;
		
		//Square step
	    for(var sx=0;sx<size-1;sx+=sideLength){
	        for(var sy=0;sy<size-1;sy+=sideLength){
	            avg = _dsGridId[# sx,sy] + _dsGridId[# sx+sideLength,sy] + _dsGridId[# sx,sy+sideLength] + _dsGridId[# sx+sideLength,sy+sideLength];
	            avg /= 4.0;


	            _dsGridId[# sx+halfSide,sy+halfSide] = 

	            avg + (random(1)*2*_height);
	        }
	    }
		
		//Diamond Step
	    for(var dx=0;dx<size-1;dx+=halfSide){
	        for(var dy=(dx+halfSide) mod sideLength;dy<size-1;dy+=sideLength){
	            avg = _dsGridId[# (dx-halfSide+size-1) mod (size-1),dy] + _dsGridId[# (dx+halfSide) mod (size-1),dy] + _dsGridId[# dx,(dy+halfSide) mod (size-1)] + _dsGridId[# dx,(dy-halfSide+size-1) mod (size-1)];
	            avg /= 4.0;
    
	            avg = avg + (random(1)*2*_height)- _height;
	            _dsGridId[# dx,dy] = avg;
	            if(dx == 0)  _dsGridId[# size-1,dy] = avg;
	            if(dy == 0)  _dsGridId[# dx,size-1] = avg;
	        }
	  }
	}


	for(var j = 0; j < size; j += 1){
	    for(var i = 0; i < size; i += 1){
	        if(ds_grid_get(_dsGridId,i,j) < 0){
	            _dsGridId[# i, j] = 0;
	        }
	        if(ds_grid_get(_dsGridId,i,j) > baseHeight){
	            _dsGridId[# i, j] = baseHeight;
	        }
	    }
	}
	return random_get_seed();
}

function diamondSquare2(_dsGridId, _height, _defaultVal, seed = undefined) {
	var size,sideLength,halfSide,avg,baseHeight;
	
	if(seed != undefined)
		random_set_seed(seed)
	else
		randomize();
	
	if(ds_grid_height(_dsGridId) != ds_grid_width(_dsGridId)){
	    show_debug_message("ERROR! Check if the ds_grid _height is equal to its width.");
	    return "ERROR";
	}
	size = ds_grid_height(_dsGridId);
	if(size < 2){
	    show_debug_message("ERROR! Invalid ds_grid size.");
	    return "ERROR";
	}
	if(size mod 2 == 0){
	    show_debug_message("WARNING: Size inappropriate. Increased by 1...");
	    size += 1;
	}
	
	//ds_grid_clear(_dsGridId,0);
	baseHeight = _height;
	
	//Setting four corners
	_dsGridId[# 0,0] = _defaultVal;
	_dsGridId[# 0,size-1] = _defaultVal;
	_dsGridId[# size-1,0] = _defaultVal;
	_dsGridId[# size-1,size-1] = _defaultVal;
	
	sideLength = size-1;
	while(sideLength >= 2){
	    sideLength /=2
	    _height/= 2.0;

	    halfSide = sideLength/2;
		
		//Square step
	    for(var sx=0;sx<size-1;sx+=sideLength){
	        for(var sy=0;sy<size-1;sy+=sideLength){
				if(_dsGridId[# sx, sy] == -1 || _dsGridId[# sx, sy] == 0)
					continue;
	            avg = _dsGridId[# sx,sy] + _dsGridId[# sx+sideLength,sy] + _dsGridId[# sx,sy+sideLength] + _dsGridId[# sx+sideLength,sy+sideLength];
	            avg /= 4.0;


	            _dsGridId[# sx+halfSide,sy+halfSide] = 

	            avg + (random(1)*2*_height);
	        }
	    }
		
		//Diamond Step
	    for(var dx=0;dx<size-1;dx+=halfSide){
	        for(var dy=(dx+halfSide) mod sideLength;dy<size-1;dy+=sideLength){
				if(_dsGridId[# dx, sy] == -1 || _dsGridId[# dx, dy] == 0)
					continue;
	            avg = _dsGridId[# (dx-halfSide+size-1) mod (size-1),dy] + _dsGridId[# (dx+halfSide) mod (size-1),dy] + _dsGridId[# dx,(dy+halfSide) mod (size-1)] + _dsGridId[# dx,(dy-halfSide+size-1) mod (size-1)];
	            avg /= 4.0;
    
	            avg = avg + (random(1)*2*_height)- _height;
	            _dsGridId[# dx,dy] = avg;
	            if(dx == 0)  _dsGridId[# size-1,dy] = avg;
	            if(dy == 0)  _dsGridId[# dx,size-1] = avg;
	        }
	  }
	}


	for(var j = 0; j < size; j += 1){
	    for(var i = 0; i < size; i += 1){
	        if(ds_grid_get(_dsGridId,i,j) < 0){
	            _dsGridId[# i, j] = 0;
	        }
	        if(ds_grid_get(_dsGridId,i,j) > baseHeight){
	            _dsGridId[# i, j] = baseHeight;
	        }
	    }
	}
	return random_get_seed();
}


function lazyFloodFill(_dsGridId, startX, startY, _decay = 0.999) {
	var visited = -1;
	var filled = 1;
	var chance = 1;
	var deck = array_create(0);
	array_push(deck, new Point(startX, startY));
	while(array_length(deck) > 0) {
		var coords = array_pop(deck);
		_dsGridId[# coords.x, coords.y] = filled;
		if(random(1) <= chance) {
			//if current cell being checked was not altered yet, set them to be visited and add them to the deck
			if(withinBoundsGrid(_dsGridId, coords.x, coords.y-1) &&
			   _dsGridId[# coords.x, coords.y-1] != filled &&
			   _dsGridId[# coords.x, coords.y-1] != visited) 
			{
				array_insert(deck, 0, new Point(coords.x, coords.y-1));
				_dsGridId[# coords.x, coords.y-1] = visited;
			}
			if(withinBoundsGrid(_dsGridId, coords.x-1, coords.y) &&
			   _dsGridId[# coords.x-1, coords.y] != filled &&
			   _dsGridId[# coords.x-1, coords.y] != visited) 
			{
				array_insert(deck, 0, new Point(coords.x-1, coords.y));
				_dsGridId[# coords.x-1, coords.y] = visited;
			}
			if(withinBoundsGrid(_dsGridId, coords.x+1, coords.y) &&
			   _dsGridId[# coords.x+1, coords.y] != filled &&
			   _dsGridId[# coords.x+1, coords.y] != visited) 
			{
				array_insert(deck, 0, new Point(coords.x+1, coords.y));
				_dsGridId[# coords.x+1, coords.y] = visited;
			}
			if(withinBoundsGrid(_dsGridId, coords.x, coords.y+1) &&
			   _dsGridId[# coords.x, coords.y+1] != filled &&
			   _dsGridId[# coords.x, coords.y+1] != visited) 
			{
				array_insert(deck, 0, new Point(coords.x, coords.y+1));
				_dsGridId[# coords.x, coords.y+1] = visited;
			}
		}
		chance *= _decay;
	}
}

function withinBoundsGrid(dsGrid, xx, yy) {
	return xx >= 0 && yy >=0 &&
		   xx < ds_grid_width(dsGrid) && yy < ds_grid_height(dsGrid);
}
	
function excavate() {
	excavate = false;
	var radius = sprite_width;
	if(sprite_height > radius)
		var radius = sprite_height;
	
	var sprLay = layer_get_id("Ground");
	var arr = layer_get_all_elements(sprLay);
	var arr2 = layer_get_all_elements(layer_get_id("OnGround"));
	var groundSprites = array_concat(arr, arr2);
	for(var i=0; i<array_length(groundSprites); i++) {
		var element = groundSprites[i];
		if(layer_get_element_type(element) == layerelementtype_sprite) {
			var xx = layer_sprite_get_x(element);
			var yy = layer_sprite_get_y(element);
			if(point_distance(x, y, xx, yy) <= radius) {
				layer_sprite_destroy(element);
				layer_sprite_create(sprLay, xx, yy, spr_grass);
			}
		}
		else if(layer_get_element_type(element) == layerelementtype_instance) {
			var inst = layer_instance_get_instance(element);
			if(point_distance(x, y, inst.x, inst.y) <= radius) {
				layer_sprite_create(sprLay, inst.x, inst.y, spr_grass);
				instance_destroy(inst);
			}
		}
	}
}
	
function pathExc() {
	var sprLay = layer_get_id("Ground");
	var arr = layer_get_all_elements(sprLay);
	var arr2 = layer_get_all_elements(layer_get_id("OnGround"));
	var groundSprites = array_concat(arr, arr2);
	for(var i=0; i<array_length(groundSprites); i++) {
		var element = groundSprites[i];
		if(layer_get_element_type(element) == layerelementtype_sprite) {
			var xx = layer_sprite_get_x(element);
			var yy = layer_sprite_get_y(element);
			var shouldExcavate = point_in_rectangle(xx, yy,
													bbox_left-sprite_height, bbox_top-sprite_height,
													bbox_right+sprite_height, bbox_bottom+sprite_height)
			//If tile is near, excavate it
			if(shouldExcavate) {
				layer_sprite_destroy(element);
				layer_sprite_create(sprLay, xx, yy, spr_grass);
			}
		}
		else if(layer_get_element_type(element) == layerelementtype_instance) {
			var inst = layer_instance_get_instance(element);
			var shouldExcavate = point_in_rectangle(inst.x, inst.y,
													bbox_left-sprite_height, bbox_top-sprite_height,
													bbox_right+sprite_height, bbox_bottom+sprite_height)
			if(shouldExcavate) {
				layer_sprite_create(sprLay, inst.x, inst.y, spr_grass);
				instance_destroy(inst);
			}
		}
	}
}