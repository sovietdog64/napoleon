draw_set_color(c_green)
draw_rectangle(
	x, y, x+rmWidth, y+rmHeight, 1
)

draw_set_color(c_gray);
for(var i=0; i<array_length(bridgedTo); i++) {
	var rm = bridgedTo[i];
	draw_line(
		x+rmWidth/2, y+rmHeight/2,
		rm.cellMid.x, rm.cellMid.y
	)
}