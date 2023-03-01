//draw_set_color(c_maroon)
//for(var r=0; r<ds_grid_width(dungeonMap); r++)
//	for(var c=0; c<ds_grid_height(dungeonMap); c++) {
//		var cellX = r*DUNG_CELL_SIZE;
//		var cellY = c*DUNG_CELL_SIZE;
//		draw_rectangle(
//			cellX, cellY,
//			cellX+DUNG_CELL_SIZE, cellY+DUNG_CELL_SIZE,
//			1
//		)
//		var p = new Line(
//			cellX, cellY,
//			cellX+DUNG_CELL_SIZE, cellY+DUNG_CELL_SIZE
//		).getMidpoint();
//		draw_circle(p.x, p.y, 100, 0)
//	}