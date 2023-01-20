if(alpha <= 0.4) switchAlpha = true;
	else if(alpha >= 1) switchAlpha = false;
if(switchAlpha == false) alpha -= 0.01;
	else alpha += 0.01;

draw_set_font(fnt_notif);
draw_set_halign(alignment);
draw_set_color(textColor);
draw_set_alpha(alpha);
draw_text_transformed(x, y, stringToDraw, size, size, angle);
draw_set_alpha(1);


duration--;
if(duration <= 0) instance_destroy();