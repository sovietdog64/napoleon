//Drawing pause screen
if(drawPauseScreen && gamePaused && !obj_player.invOpen) {
	draw_set_alpha(0.5);
	//Set translucent background
	draw_rectangle_color(0, 0, camWidth(), camHeight(), c_black,c_black,c_black,c_black, false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_text_transformed(camWidth()/2, camHeight()/2, "GAME PAUSED", 5, 5, 0);
	draw_set_color(c_yellow);
	draw_text_transformed(camWidth()/2, 70+(camHeight()/2), "Press <ESC> again to continue", 3, 3, 0);
	
	draw_sprite(spr_saveBtn, 0, camWidth()*0.9, 50);
	draw_sprite(spr_loadBtn, 0, camWidth()*0.9, 150);
	if(point_in_rectangle(mouse_x-camX(), mouse_y-camY(), camWidth()*0.9, 50, 128+camWidth()*0.9, 50+64)) {
		draw_set_color(c_black);
		draw_circle(mouse_x-camX(), mouse_y-camY(), 8, 1);
		if(mouse_check_button_pressed(mb_left)) {
			saveGame();
		}
	}
	else if(point_in_rectangle(mouse_x-camX(), mouse_y-camY(), camWidth()*0.9, 150, 128+camWidth()*0.9, 150+64)) {
		draw_set_color(c_black);
		draw_circle(mouse_x-camX(), mouse_y-camY(), 8, 1);
		if(mouse_check_button_pressed(mb_left)) {
			loadGame();
		}
	}
}
