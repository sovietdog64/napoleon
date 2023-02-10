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

function diamondSquare(chunkSize, squareSize = 5, roughness = 2) {
	randomize();
	var mapSize = power(2, chunkSize) + 1;
	var map = ds_grid_create(mapSize, mapSize);
	//four corners
	ds_grid_set(map, 0, 0, irandom_range(1, 4));
	ds_grid_set(map, mapSize, 0, irandom_range(1, 4));
	ds_grid_set(map, 0, mapSize, irandom_range(1, 4));
	ds_grid_set(map, mapSize, mapSize, irandom_range(1, 4));
	
	var size = mapSize-1;
	while(size > 1) {
		var half = numRound(size/2);
		
		//square step
		for(var xx=0; xx<mapSize-1; xx += size) 
			for(var yy=0; yy<mapSize-1; yy += size) {
				var val = (ds_grid_get(map, xx, yy) +
						  ds_grid_get(map, xx+size, yy) +
						  ds_grid_get(map, xx, yy+size) +
						  ds_grid_get(map, xx+size, yy+size)) /
						  4 + irandom_range(-roughness, roughness)
				ds_grid_set(map, xx+half, yy+half, val);
			}
		
		//diamond step
		for(var xx=0; xx<mapSize-1; xx += size) 
			for(var yy=0; yy<mapSize-1; yy += size) {
				var midTop = (ds_grid_get(map, xx, yy) +
							 ds_grid_get(map, xx+half, yy+half) +
							 ds_grid_get(map, xx, yy+size)) /
							 3 + irandom_range(-roughness, roughness);
				var midBottom = (ds_grid_get(map, xx, yy+size) +
								ds_grid_get(map, xx+half, yy+half) +
								ds_grid_get(map, xx+size, yy+size)) /
								3 + irandom_range(-roughness, roughness);
				var midLeft = (ds_grid_get(map, xx, yy) +
							  ds_grid_get(map, xx+half, yy+half) +
							  ds_grid_get(map, xx, yy+size)) /
							  3 + irandom_range(-roughness, roughness);
				var midRight = (ds_grid_get(map, xx+size, yy) +
							   ds_grid_get(map, xx+half, yy+half) +
							   ds_grid_get(map, xx+size, yy+size)) /
							   3 + irandom_range(-roughness, roughness);
							   
				ds_grid_set(map, xx+half, yy, midTop);
				ds_grid_set(map, xx+half, yy+size, midBottom);
				ds_grid_set(map, xx, yy+half, midLeft);
				ds_grid_set(map, xx+size, yy+half, midRight);
			}
			
		size /= 2;
		size = numRound(size);
		roughness /= 2;
		roughness = numRound(roughness);
	}
	return map;
	
	
	//var mapChunkSize = mapSize - 1;
	//while(mapChunkSize > 1) {
	//	var half = numRound(mapChunkSize/2);
		
	//	#region square step
	//	for(var	yy = 0; yy<mapChunkSize; yy++) 
	//		for(var	xx = 0; xx<mapChunkSize; xx++) {
	//			var val = (ds_grid_get(map, yy, xx) +
	//					   ds_grid_get(map, yy, xx+mapChunkSize) +
	//					   ds_grid_get(map, yy+mapChunkSize, xx) +
	//					   ds_grid_get(map, yy+mapChunkSize, xx+mapChunkSize)) /
	//					   4 + irandom_range(-roughness, roughness)
	//			ds_grid_set(map, yy+half, xx+half, val);
	//		}
	//	#endregion square step
		
	//	#region diamond step
	//	for(var i=0; i<half; i++)
	//	#endregion diamond step
	//	mapChunkSize /= 2;
	//	roughness /= 2;
	//}
}