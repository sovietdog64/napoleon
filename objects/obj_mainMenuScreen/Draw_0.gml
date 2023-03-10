surface_set_target(application_surface);
	if(surface_exists(preview)) {
		draw_surface(preview, 0,0);
	}
	else
		preview = surface_create(RESOLUTION_W, RESOLUTION_H);
surface_reset_target();

draw_set_halign(fa_left);
screen.drawScreen();