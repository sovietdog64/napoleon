draw_self();
var x2 = x+lengthdir_x(spd, direction-180);
var y2 = y+lengthdir_y(spd, direction-180);
draw_sprite_pos(spr_bulletFlash, 0, x, y, x2, y2, x+5, y+5, x-5, y-5, 1);