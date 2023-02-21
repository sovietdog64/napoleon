draw_self();
if(hp < maxHp) {
	var subimg = 0;
	var percent = hp/maxHp;
	if(percent <= 0.25)
		subimg = 3;
	else if(percent <= 0.5)
		subimg = 2;
	else if(percent <= 0.75)
		subimg = 1;
	else if(percent <= 0.9)
		subimg = 0;
	draw_sprite_stretched(spr_placeableBreak, subimg, x, y, sprite_width, sprite_height);
}