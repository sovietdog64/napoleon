if(isItem(itemDrag)) {
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	var half = SLOT_SIZE/2;
	draw_sprite(itemDrag.itemSpr, 0, mx-half, my-half);
}