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
