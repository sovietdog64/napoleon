var inst = collision_point(mouse_x, mouse_y, obj_tree, 0, 1);

if(inst != noone)
	show_debug_message(structifyInstance(inst))