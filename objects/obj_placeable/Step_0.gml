if(global.screenOpen || global.gamePaused)
	return;

var hovered = point_in_rectangle(
	mouse_x, mouse_y,
	bbox_left,bbox_top,bbox_right,bbox_bottom,
)
if(hovered) {
	if(mouse_check_button_pressed(mb_right)) {
		rightClick();
	}
}