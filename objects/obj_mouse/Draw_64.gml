if(isItem(itemDrag)) {
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	var half = INV_SLOT_SIZE/2;
	draw_sprite_stretched(itemDrag.itemSpr, 0, mx-half, my-half, INV_ITEM_SIZE, INV_ITEM_SIZE);
}