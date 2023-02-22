//drawing chunks
var xCount = ds_grid_width(allChunks);
var yCount = ds_grid_height(allChunks);
for(var xx=0; xx<xCount; xx++) {
	for(var yy=0; yy<yCount; yy++) {
		draw_set_color(c_red);
		draw_rectangle(xx*PX_CHUNK_W, yy*PX_CHUNK_W, xx*PX_CHUNK_W+PX_CHUNK_W, yy*PX_CHUNK_W+PX_CHUNK_W, 1);
	}
}

//for(var xx=0; xx<ds_grid_width(terrainMap); xx++)
//	for(var yy=0; yy<ds_grid_height(terrainMap); yy++) {
//		if(numRound(terrainMap[# xx, yy]) == 6)
//			draw_circle(xx*TILEW, yy*TILEW, 10, 0);
//	}