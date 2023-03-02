var inst = collision_point(mouse_x, mouse_y, obj_tree, 0, 1);

variable_instance_set(inst, "elkgjarnlbjkab", function() {show_debug_message("aee")})


if(inst != noone)
	clipboard_set_text(json_stringify(structifyInstance(inst)));