draw_self();
{//Drawing health bar
	draw_set_color(c_black);
	var xx = x-sprite_width/2;
	var yy = (y-sprite_height/2)-20;
	var yy2 = yy+15;
	draw_rectangle(xx, yy, x+sprite_width/2, yy2, 0);
	draw_set_color(c_green);
	draw_rectangle(xx+1, yy+1, (x+(sprite_width/2)*(hp/maxHp))-1, yy2-1, 0);
}