draw_self();
if(hp == 0)
	return;
var w = sprite_width/2;
var h = sprite_height/2; 
draw_healthbar(
	x-w, y-h-7,
	x+w, y-h-1,
	(hp/maxHp)*100, c_black, c_red, c_green, 0, 1, 1
)