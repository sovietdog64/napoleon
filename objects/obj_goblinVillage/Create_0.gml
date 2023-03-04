if(variable_instance_exists(id, "noCreateEvent") && noCreateEvent)
	return;
event_inherited();

huts = [];

radius = choose(TILEW*4, TILEW*8);

for(var i=0; i<irandom_range(2, 5); i++) {
	//Get random position in village radius
	var p = randPointInCircle(radius);
	var maxIterations = 100;
	var iterations = 0;
	while(collision_circle(x+p.x, y+p.y, HIGHEST_HOUSE_H, obj_hut, 0, 1) != noone && iterations <= maxIterations) {
		iterations++;
		p = randPointInCircle(radius, true);
	}
	//If house can spawn in this point,
	//spawn it and add it to huts array.
	var inst = instance_create_layer(x+p.x, y+p.y, layer, obj_hut);
	inst.sprite_index = choose(spr_hut);
	array_push(huts, inst);
}

mapSize = power(2, 4)+1;

excavationMap = ds_grid_create(mapSize, mapSize);

lazyFloodFill(excavationMap, floor(mapSize/2), floor(mapSize/2), 0.995)

alarm_set(0, 5);