if(!loaded)
	return;
	
while(excavate && excavateIterations <= 3) {
	if(timer > 0)
		timer--;
	else if(excavate) {
		excavateIterations++;
		var sprLay = layer_get_id("Ground");
		var arr = layer_get_all_elements(sprLay);
		var arr2 = layer_get_all_elements(layer_get_id("OnGround"));
		var groundSprites = array_concat(arr, arr2);
		for(var i=0; i<array_length(groundSprites); i++) {
			var element = groundSprites[i];
			if(layer_get_element_type(element) == layerelementtype_sprite) {
				var xx = layer_sprite_get_x(element);
				var yy = layer_sprite_get_y(element);
				var shouldExcavate = point_in_rectangle(xx, yy,
														bbox_left-sprite_height, bbox_top-sprite_height,
														bbox_right+sprite_height, bbox_bottom+sprite_height)
				//If tile is near, excavate it
				if(shouldExcavate) {
					layer_sprite_destroy(element);
					layer_sprite_create(sprLay, xx, yy, spr_grass);
				}
			}
			else if(layer_get_element_type(element) == layerelementtype_instance) {
				var inst = layer_instance_get_instance(element);
				var shouldExcavate = point_in_rectangle(inst.x, inst.y,
														bbox_left-sprite_height, bbox_top-sprite_height,
														bbox_right+sprite_height, bbox_bottom+sprite_height)
				if(shouldExcavate) {
					layer_sprite_create(sprLay, inst.x, inst.y, spr_grass);
					instance_destroy(inst);
				}
			}
		}
	}
}