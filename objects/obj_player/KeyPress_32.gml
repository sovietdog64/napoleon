
saveRoom2();
loadRoom2();

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