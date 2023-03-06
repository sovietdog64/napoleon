if(sprite_exists(sprite_index))
	draw_self();

draw_set_color(c_white);
draw_set_font(fnt_hud);
draw_set_halign(fa_center);
draw_set_valign(fa_center);
try {
	draw_text(x+sprite_width, y+sprite_width, string(item.amount))
} catch(err) {}