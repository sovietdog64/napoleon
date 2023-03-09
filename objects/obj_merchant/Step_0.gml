if(!instance_exists(obj_text) || !instance_exists(obj_textQueued)) {
	if(point_in_rectangle(mouse_x, mouse_y, bbox_left,bbox_top, bbox_right,bbox_bottom) && LMOUSE_PRESSED) {
		newTextBox(
			"See if you need anything."
		);
	}
}