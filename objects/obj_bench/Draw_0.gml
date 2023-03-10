draw_self();
if(!instance_exists(obj_game)) 
	return;
if(!instance_exists(obj_player)) 
	return;
if(obj_player.inDialogue) 
	return;
	
if(distance_to_point(obj_player.x, obj_player.y) <= 100) {
	draw_set_font(fnt_notif);
	draw_set_color(c_grey);
	draw_set_halign(fa_center);
	draw_text_transformed(x, y-70, "Press W to set spawnpoint", 2.5, 2.5, 0);
	if(keyboard_check_pressed(ord("W"))) {
		global.spawnX = x;
		global.spawnY = y;
		global.spawnRoom = room;
		drawNotification(x, y-140, "Spawnpoint set.", c_white, room_speed*2, 2, fa_center, 0);
		saveGame();
		drawNotification(x, y-170, "Game saved.", c_yellow, room_speed*2, 2, fa_center, 0);
	}
}