draw_self();
var offX = sprite_get_xoffset(sprite_index)
var offY = sprite_get_yoffset(sprite_index)
sprite_set_offset(sprite_index, sprite_width/2, sprite_height/2);
var w = sprite_width/2;
var h = sprite_height/2; 
draw_healthbar(
	x-w, y-h-7,
	x+w, y-h-1,
	(hp/maxHp)*100, c_black, c_red, c_green, 0, 1, 1
)
sprite_set_offset(sprite_index, offX, offY);