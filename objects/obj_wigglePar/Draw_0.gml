
for(var i=0; i<9; i++) {
	if(i == 0)
		draw_line(x, y, allObjs[i].x, allObjs[i].y);
	else
		draw_line(allObjs[i].x, allObjs[i].y, allObjs[i+1].x, allObjs[i+1].y);
}