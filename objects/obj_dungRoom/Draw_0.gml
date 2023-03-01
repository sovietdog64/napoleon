draw_set_color(c_red)
draw_rectangle(
	x, y,
	x+rmWidth, y+rmHeight,
	1
)

draw_set_color(c_gray);
for(var i=0; i<array_length(bridgedTo); i++) {
	var rm = bridgedTo[i];
	draw_line(
		x+rmWidth/2, y+rmHeight/2,
		rm.cellMid.x, rm.cellMid.y
	)
}

draw_set_color(c_maroon)
for(var i=0; i<array_length(bridgedTo); i++) {
	var rmMapPos = mapPos.copy();
	var diff = bridgedTo[i].mapPos.copy();
	diff.subtractVec(rmMapPos);
	diff.normalize();
	
	diff.x *= rmWidth/2;
	diff.y *= rmHeight/2;
	
	var doorPos = new Vector2(cellMid.x, cellMid.y);
	doorPos.addVec(diff);
	
	draw_circle(doorPos.x, doorPos.y, 100, 0)
	
}
