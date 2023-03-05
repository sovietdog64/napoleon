var startX = x-radius;
var startY = y-radius;
for(var xx=0; xx<mapSize; xx++)
	for(var yy=0; yy<mapSize; yy++) {
		if(excavationGrid[# xx, yy] <= 0)
			continue;
		var pxX = xx*TILEW;
		var pxY = yy*TILEW;
		var inst = collision_rectangle(
			startX+pxX, startY+pxY,
			startX+pxX+TILEW, startY+pxY+TILEW,
			obj_resourcePar, 0, 1
		)
		if(inst != noone)
			instance_destroy(inst);
	}