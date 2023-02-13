if(global.cutscene) return;
var c;
draw_set_color(c_white);
draw_set_font(fnt_hud);  
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
var temp = 100 * (global.xp/global.levelUpThreshold);
var c = make_color_rgb(26, 199, 187)
draw_healthbar(RESOLUTION_W*0.01, RESOLUTION_H*0.12,
			   RESOLUTION_W*0.4, RESOLUTION_H*0.12+20,
			   temp,
			   c_black,
			   c,
			   c,
			   1,
			   true,
			   true)
			   
draw_text_transformed(RESOLUTION_W*0.01, RESOLUTION_H*0.12,
					  "Level " + string(global.level),
					  1,1,0);

draw_set_halign(fa_center)
draw_set_valign(fa_center);
var p = lineMidpoint(RESOLUTION_W*0.01, RESOLUTION_H*0.12, RESOLUTION_W*0.4, RESOLUTION_H*0.12+20)
draw_text(p.x, p.y+7, string(global.xp) + "/" + string(global.levelUpThreshold) + " XP");