draw_set_color(make_color_rgb(97, 70, 6))
draw_circle(x, y, 10, 0);
for(var i=0; i<array_length(roads); i++) {
	var l = roads[i].line;
	draw_line(l.x1, l.y1, l.x2, l.y2);
}