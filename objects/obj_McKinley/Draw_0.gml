draw_self();
{//Drawing health bar
	var xx = sprite_width/2;
	var yy = sprite_height*0.7;
	draw_set_color(make_color_rgb(150, 97, 5));
	draw_rectangle(x - xx, y-yy, x + xx, (y - yy)+10, 0);
	draw_set_color(c_green);
	draw_rectangle((x - xx)+2, (y - yy)+2, x + (xx-2)*(hp/maxHp), (y - yy)+8, 0);
}