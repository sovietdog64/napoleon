
saveRoom2();


//var struct = {instances : [], deactivatedInstances : [], instMem : {}};
//var inst = instance_create_depth(x, y, depth, obj_tree);
//instance_deactivate_object(inst);
//var struct2 = {
//	test : {
//		thing : instance_create_depth(x+64, y, depth, obj_tree)
//	}
//}
//variable_instance_set(inst, "test_thing", struct2)
//var memAddress = structifyInstance(inst, struct);
//var playerAddr = struct.instMem[$ memAddress].test_thing.test.thing;
//structToInstance(struct.instMem[$ memAddress])
//clipboard_set_text(json_stringify(struct.instMem[$ memAddress]));


return;

var inst = collision_point(mouse_x, mouse_y, obj_tree, 0, 1);
show_debug_message("ee")
if(inst != noone) {
	var s = structifyInstance(inst);
	instance_destroy(inst);
	inst = instance_create_depth(x+64, y, depth, obj_tree);
	var s2 = structifyInstance(inst);
	instance_destroy(inst);
	var arr3 = [s2];
	variable_struct_set(s, "thing", arr3);
	clipboard_set_text(json_stringify(s))
	show_debug_message(structToInstance(s));
}