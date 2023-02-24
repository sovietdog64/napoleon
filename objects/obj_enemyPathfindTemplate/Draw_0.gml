draw_self();
if(hp == 0)
	return;

var w = sprite_width;

{//Drawing health bar
	var x1 = x-(w/2)-1;
	var y1 = bbox_top-sprite_height;
	draw_set_color(c_black);
	draw_rectangle(x1,y1, x1+w+1, y1+7, 0);
	draw_set_color(c_green);
	draw_rectangle(x1+1,y1+1, x1+(w*hp/maxHp), y1+6, 0);
}