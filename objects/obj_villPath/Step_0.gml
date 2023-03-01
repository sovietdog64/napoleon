

var inst = instance_place(x, y, obj_resourcePar);
if(inst != noone) {
	instance_destroy(inst);
}

if(destroy) {
	instance_destroy();
	return;
}