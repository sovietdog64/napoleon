if(instance_exists(obj_player)) {
	for(var col=0; col<ds_grid_width(chunkGrid); col++) {
		for(var row=0; row<ds_grid_height(chunkGrid); row++) {
			var r = ds_grid_get(chunkGrid, col, row);
			var camInBounds = rectangle_in_rectangle(CAMX,CAMY, CAMX+RESOLUTION_W,CAMY+RESOLUTION_H, 0,0, generatedX, generatedY);
			
		}
	}
}