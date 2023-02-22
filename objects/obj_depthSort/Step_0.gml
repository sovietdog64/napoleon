//Get list of all objects
ds_list_clear(drawList);
var num = collision_rectangle_list(CAMX, CAMY, CAMX2, CAMY2, all, 0, 1, drawList, 0);

//Sort the objects based on their y value
for(var i=0; i<num; i++) {
	var inst = drawList[| i];
	//Prevent adding game-control objects/tiles
	if(inst.persistent || object_is_ancestor(inst.object_index, obj_tilePar))
		continue;
	ds_priority_add(drawQueue, inst, inst.y);
}

for(var i=0; i<ds_priority_size(drawQueue); i++) {
	var inst = ds_priority_delete_min(drawQueue);
	inst.depth = -i;
}