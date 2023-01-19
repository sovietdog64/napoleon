if(global.cutscene) return;
var c;
draw_set_color(c_white);
draw_set_font(fnt_hud);
draw_set_halign(fa_left)  
draw_text_transformed(7, 20, "Level " + string(global.level), 1,1,0);
c = c_black;
draw_rectangle_color(7, 37, 403, 73, c,c,c,c, 0);
c  = make_color_rgb(133, 98, 1);
draw_rectangle_color(10,40, 400, 70, c,c,c,c, 0);
c = c_green
var temp = 400 * (global.xp/global.levelUpThreshold);
if(global.xp <= 0) temp = 10;
draw_rectangle_color(10,40, temp, 70, c,c,c,c, 0);
draw_set_halign(fa_center);
draw_text(200, 45, string(global.xp) + "/" + string(global.levelUpThreshold) + " XP");