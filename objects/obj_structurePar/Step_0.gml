if(!loaded)
	return;

var list = ds_list_create()
var num = instance_place_list(x, y, obj_resourcePar, list, 0);
if(num > 0) {
	for(var i=0; i<ds_list_size(list); i++)
		instance_destroy(list[| i]);
}