if(room == rm_init || room == rm_mainMenu)
	return;

gpu_set_blendenable(false);
if(global.gamePaused) {
	surface_set_target(application_surface);
		if(surface_exists(pauseSurf))
			draw_surface(pauseSurf,0,0);
		else {
			pauseSurfaceBuf = surface_create(RESOLUTION_W, RESOLUTION_H);
			buffer_set_surface(pauseSurfaceBuf, pauseSurf, 0);
		}
	surface_reset_target();
}

if(keyboard_check_pressed(vk_escape)) {
	if(!global.gamePaused) {
		global.gamePaused = true;
		
		pausedInstances = [];
		
		with(all) {
			if(!persistent && object_index != obj_player && !object_is_ancestor(object_index, obj_guiScreenPar)) {
				array_push(other.pausedInstances, id);
				instance_deactivate_object(id);
			}
		};
		
		pauseSurf = surface_create(RESOLUTION_W, RESOLUTION_H);
		surface_set_target(pauseSurf);
		draw_surface(application_surface, 0,0);
		surface_reset_target();
		
		if(buffer_exists(pauseSurfaceBuf))
			buffer_delete(pauseSurfaceBuf);
		pauseSurfaceBuf = buffer_create(RESOLUTION_W*RESOLUTION_H*4, buffer_fixed, 1);
		buffer_get_surface(pauseSurfaceBuf, pauseSurf, 0);
		
		instance_create_depth(0,0,0,obj_pauseScreen);
	}
	else {
		global.gamePaused = false;
		
		instance_activate_all();
		pausedInstances = [];
		
		if(surface_exists(pauseSurf))
			surface_free(pauseSurf);
		if(buffer_exists(pauseSurfaceBuf))
			buffer_delete(pauseSurfaceBuf);
	
		instance_destroy(obj_pauseScreen);
	}
}

gpu_set_blendenable(true);