var mx = mouse_x-CAMX;
var my = mouse_y-CAMY;
if(is_method(action))
	if(point_in_rectangle(mx, my, bbox_left,bbox_top, bbox_right, bbox_bottom) && mouse_check_button_pressed(mb_left))
		action();