//Was trying to make infinitely-generating world
return;

if(instance_exists(obj_player)) {
	for(var col=0; col<ds_grid_width(chunkGrid); col++) {
		for(var row=0; row<ds_grid_height(chunkGrid); row++) {
			var r = ds_grid_get(chunkGrid, col, row);
			if(distanceToRectangle(obj_player.x, obj_player.y, r.x1,r.y1, r.x1,r.y2) <= RESOLUTION_W) 
			{
				
			}
		}
	}
}