//drawing chunks
for(var i=0; i<ds_grid_width(chunkGrid); i++) {
	for(var j=0; j<ds_grid_height(chunkGrid); j++) {
		var r = ds_grid_get(chunkGrid, i, j);
		draw_rectangle(r.x1, r.y1, r.x2, r.y2, 1)
	}
}