var list = ds_list_create();
collision_rectangle_list(
	bbox_left, bbox_top, bbox_right, bbox_bottom,
	obj_resourcePar,
	0,1,
	list,
	0
)
for(var i=0; i<ds_list_size(list); i++) {
	instance_destroy(list[| i])
}

move_snap(TILEW, TILEW);