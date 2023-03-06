///@desc draw textbox

nineSliceBoxStretched(spr_textBoxes, x1, y1, x2, y2, frame);
draw_set_font(fnt_npc);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var print = string_copy(textMsg, 1, textProgress);

if(responses[0] != -1 && textProgress >= string_length(textMsg)) {
	for(var i=0; i<array_length(responses); i++) {
		print += "\n";
		if(i == responseSelected) 
			print += "> ";
		print += responses[i];
		if(i == responseSelected)
			print += " <";
	}
}

draw_set_color(c_black);
draw_text_transformed((x1+x2)/2, y1+8, print, 1, 1, 0);
draw_set_color(c_white);
draw_text_transformed((x1+x2)/2, y1+7, print, 1, 1, 0);

draw_set_color(c_yellow);
draw_text_transformed(RESOLUTION_W*0.85, RESOLUTION_H*0.6, "Press <SPACE> to continue", 1.5, 1.5, 0);