if(isItem(itemDrag)) {
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	var half = SLOT_SIZE/2;
	draw_sprite(itemDrag.itemSpr, 0, mx-half, my-half);
}


//for(var i=0; i<instance_number(obj_inventory); i++) {
//	var inv = instance_find(obj_inventory, i);
//	with(inv) {
//		draw_set_color(c_gray)
//		draw_rectangle(invRect[0].x, invRect[0].y, invRect[1].x, invRect[1].y, 0)
//		draw_set_color(c_green)
//		for(var j=0; j<invSize; j++) {
//			var p = slotPositions[j];
//			draw_rectangle(p.x, p.y, p.x+64, p.y+64, 0);
//		}
//	}
//}