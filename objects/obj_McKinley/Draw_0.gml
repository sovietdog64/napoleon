draw_self();
{//Drawing health bar
	draw_set_color(c_black);
	draw_rectangle(x - 22, y-sprite_height, x + 22, (y - 10)-sprite_height, 0);
	draw_set_color(c_green);
	draw_rectangle(x - 20, y-sprite_height+2, (x - 20) + 40 * (hp/maxHp), (y - 8)-sprite_height, 0);
}