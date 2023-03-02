//Get list of all objects
ds_list_clear(drawList);
var num = collision_rectangle_list(0, 0, room_width, room_height, all, 0, 1, drawList, 0);

//Sort the objects based on their y value
for(var i=0; i<num; i++) {
	var inst = drawList[| i];
	if(!instance_exists(inst)) {
		ds_priority_delete_value(drawList, inst);
		continue;
	}
	//Prevent adding game-control objects/tiles
	if(inst.persistent || object_is_ancestor(inst.object_index, obj_noDepthSortPar))
		continue;
	
	ds_priority_add(drawQueue, inst, inst.bbox_bottom);
}

for(var i=0; i<ds_priority_size(drawQueue); i++) {
	var inst = ds_priority_delete_min(drawQueue);
	if(instance_exists(inst))
		inst.depth = -i;
}