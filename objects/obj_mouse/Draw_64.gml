if(isItem(itemDrag)) {
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	var half = INV_SLOT_SIZE/2;
	draw_sprite_stretched(itemDrag.itemSpr, 0, mx-half, my-half, INV_ITEM_SIZE, INV_ITEM_SIZE);
	if(itemDrag.amount > 1) {
		draw_set_color(c_white);
		draw_set_font(fnt_hud);
		draw_set_halign(fa_center);
		draw_text(mx+half, my+half, string(itemDrag.amount))
	}
	
	var hoverText = itemDrag.name + "\n" + string(itemDrag.desc);
	
	draw_set_color(c_black)
	draw_set_alpha(0.5);
	draw_rectangle(
		GUI_MOUSE_X, GUI_MOUSE_Y,
		GUI_MOUSE_X+string_width(hoverText)+20, GUI_MOUSE_Y+string_height(hoverText)+20,
		0
	)
	draw_set_alpha(1);
	
	var h = draw_get_halign()
	var v = draw_get_valign()
				
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_text(GUI_MOUSE_X+10, GUI_MOUSE_Y+10, hoverText);
				
	draw_set_halign(h);
	draw_set_valign(v);
}
	
else if(slotHover != -1 && invHover != -1 && isItem(invHover[slotHover])) {
	var item = invHover[slotHover];
	var hoverText = item.name + "\n" + string(item.desc);
	
	draw_set_color(c_black)
	draw_set_alpha(0.5);
	draw_rectangle(
		GUI_MOUSE_X, GUI_MOUSE_Y,
		GUI_MOUSE_X+string_width(hoverText)+20, GUI_MOUSE_Y+string_height(hoverText)+20,
		0
	)
	draw_set_alpha(1);
	
	var h = draw_get_halign()
	var v = draw_get_valign()
				
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_text(GUI_MOUSE_X+10, GUI_MOUSE_Y+10, hoverText);
				
	draw_set_halign(h);
	draw_set_valign(v);
}