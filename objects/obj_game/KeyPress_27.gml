///@description Pause screen
if(room == rm_mainMenu || room == rm_init)
	return;

////If not paused & screens are open when esc is pressed, exit those screens.
//if((instance_exists(obj_inventory) || instance_exists(obj_guiScreenPar)) && !instance_exists(obj_pauseScreen)) {
//	closeAllScreens();
//	return;
//}

////If is paused, then toggle pause screen
//global.gamePaused = !global.gamePaused;
//if(global.gamePaused) {
//	with(all) {
//		if(!persistent && object_index != obj_pauseScreen) {
//			array_push(other.pausedInstances, id);
//			instance_deactivate_object(id);
//		}
//	}
	
	
//	pauseSurf = surface_create(RESOLUTION_W, RESOLUTION_H);
//	surface_set_target(pauseSurf);
//	draw_surface(application_surface, 0,0);
//	surface_reset_target();
	
//	if(buffer_exists(pauseSurfaceBuf))
//		buffer_delete(pauseSurfaceBuf);
//	pauseSurfaceBuf = buffer_create(RESOLUTION_W*RESOLUTION_H*4, buffer_fixed, 1);
//	buffer_get_surface(pauseSurfaceBuf, pauseSurf, 0);
	
//	instance_create_depth(0,0,0,obj_pauseScreen)
//}
//else {
//	for(var i=0; i<array_length(pausedInstances); i++)
//		instance_activate_object(pausedInstances[i]);
	
//	pausedInstances = [];
	
//	if(surface_exists(pauseSurf))
//		surface_free(pauseSurf);
//	if(buffer_exists(pauseSurfaceBuf))
//		buffer_delete(pauseSurfaceBuf)
	
//	instance_destroy(obj_pauseScreen)
//}
	
