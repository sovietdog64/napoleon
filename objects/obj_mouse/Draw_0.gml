if(selectedObj != noone) {
	draw_set_color(c_black);
	var inst = selectedObj;
	draw_rectangle(
		inst.x, inst.y,
		inst.x+inst.sprite_width, inst.y+inst.sprite_height,
		1
	)
}