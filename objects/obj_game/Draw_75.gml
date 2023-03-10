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
gpu_set_blendenable(true);