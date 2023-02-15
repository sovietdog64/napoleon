if(room == rm_init)
	return;
layerId = layer_get_id("Ground");
randomize();
grassMap = new cellular_automata_map(30, 30, 0.7, 5, 5);
grassMap.iterate(10);
waterMap = new cellular_automata_map(30, 30, 0.1, 5, 3);
spawnSquares(grassMap, spr_grass, 1, 0, 0);
//spawnSquares(waterMap, spr_water, 2, 0, 0)

generatedWidth = 30;
generatedHeight = 30;