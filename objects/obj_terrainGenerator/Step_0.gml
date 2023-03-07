if(chunkLoadTimer > 0) {
	chunkLoadTimer--;
	return;
}

chunkLoadTimer = global.chunkLoadDelay;

if(room == rm_dungeon)
	return;
var xCount = ds_grid_width(global.chunksGrid);
var yCount = ds_grid_height(global.chunksGrid);

if(instance_exists(obj_player))
	for(var i=0; i<instance_number(all); i++) {
		var inst = instance_find(all, i);
		var ind = inst.object_index;
		if(inst.persistent || ind == obj_player ||
			object_is_ancestor(ind, obj_inventory) ||
			object_is_ancestor(ind, obj_guiScreenPar) ||
			ind == obj_inventory ||
			ind == obj_damageHitbox ||
			ind == obj_text ||
			ind == obj_textQueued)
			continue;
		
		
		var inRenderDist = true;
		with(inst) {
			inRenderDist = distance_to_object(obj_player) <= global.renderDist*TILEW
		}
		
		if(!inRenderDist) {
			instance_deactivate_object(inst);
			array_push(deactivatedInstances, inst);
		}
	}
	
var len = array_length(deactivatedInstances);
if(instance_exists(obj_player))
	for(var i=0; i<len; i++) {
		var inst = deactivatedInstances[i];
		
		try {
			var inRenderDist = rectangle_in_circle(
				inst.bbox_left, inst.bbox_top, inst.bbox_right, inst.bbox_bottom,
				obj_player.x, obj_player.y,
				TILEW*global.renderDist
			)
	
			if(inRenderDist) {
				instance_activate_object(inst);
				array_delete(deactivatedInstances, i, 1);
				len = array_length(deactivatedInstances);
			}
		} catch(err) {}
		
	}

//Loop through all chunks and see if it is unloaded and visible at the same time.
//if it is, then load the chunk
for(var xx=0; xx<xCount; xx++) {
	for(var yy=0; yy<yCount; yy++) {
		var chunkX = xx*PX_CHUNK_W;
		var chunkY = yy*PX_CHUNK_H;
		
		var chunk = global.chunksGrid[# xx, yy];
		
		var camInBounds = rectangle_in_rectangle(CAMX, CAMY, CAMX2, CAMY2,
												chunkX, chunkY, chunkX+PX_CHUNK_W, chunkY+PX_CHUNK_H);
		if(camInBounds && !chunk.loaded) {
			chunk.loaded = true;
			currentChunk = chunk;
			placeChunk(xx,yy);
			//Put this here in order to let chunks place their non-tile instances if its their
			//first time being loaded.
			//After this, the chunks wont re-make resources/instances that are not tiles
			chunk.previouslyLoaded = true;
		}
	}
}