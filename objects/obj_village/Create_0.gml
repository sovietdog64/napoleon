buildings = [];

roads = [];

largestLen = 0;

randomize();

for(var i=0; i<irandom_range(10, 11); i++) {
	var spr = choose(spr_house, spr_house2, spr_house3, spr_house4);
	var inst = instance_create_layer(x, y, "Structures", obj_house)
	inst.sprite_index = spr;
	array_push(buildings, inst);
	if(inst.sprite_width > largestLen)
		largestLen = inst.sprite_width
	if(inst.sprite_height > largestLen)
		largestLen = inst.sprite_height
}

for(var i=0; i<361; i += 90) {
	var xx = x+lengthdir_x(largestLen*3, i)
	var yy = y+lengthdir_y(largestLen*3, i)
	var struct = {
		line : new Line(x, y, xx, yy),
		plots : array_create(3, 0),
	}
	array_push(roads, struct);
	//Extending line has 30% chance of spawning
	if(irandom_range(1, 100) <= 30) {
		var dir = choose(0, 90, 180, 270);
		var xx2 = xx+lengthdir_x(largestLen*3, dir);
		var yy2 = yy+lengthdir_y(largestLen*3, dir);
		var struct = {
			line : new Line(xx, yy, xx2, yy2),
			plots : array_create(3, 0),
		}
		array_push(roads, struct);
	}
}

for(var i=0; i<array_length(buildings); i++) {
	var foundPlot = false;
	var slotPos = -1;
	var road;
	//finding road with enough Plots
	//If there is an avilable plot, add the building to it
	//else, break and delete house(s)
	for(var j=0; j<array_length(roads); j++) {
		var road = roads[j];
		for(var k=0; k<array_length(roads[j].plots); k++) {
			if(road.plots[k] == 0) {
				road.plots[k] = buildings[i];
				slotPos = k;
				foundPlot = true;
				break;
			}
		}
		if(foundPlot)
			break;
	}
	//Deleting houses if there isn't enough space for more
	if(!foundPlot) {
		var f = function(_element, _index) {
			instance_destroy(_element)
		}
		array_foreach(buildings, f, i);
		array_delete(buildings, i, array_length(buildings)-i);
		break;
	}
	var l = road.line;
	var buildingLength = buildings[i].sprite_width;
	if(buildings[i].sprite_height > buildingLength) 
		buildingLength = buildings[i].sprite_height;
	var len = l.length*0.3*(k+1);
	var dir = point_direction(l.x1, l.y1, l.x2, l.y2);
	var xx = l.x1 + lengthdir_x(len, dir);
	var yy = l.y1 + lengthdir_y(len, dir);
	buildings[i].x = xx;
	buildings[i].y = yy;
	buildings[i].image_angle = dir-90;
}