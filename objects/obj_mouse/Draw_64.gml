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
}