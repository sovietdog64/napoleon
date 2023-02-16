if(timer > 0)
	timer--;
else if(excavate) {
	excavate = false;
	var radius = sprite_width;
	if(sprite_height > radius)
		var radius = sprite_height;
	
	var sprLay = layer_get_id("Ground");
	var arr = layer_get_all_elements(sprLay);
	var arr2 = layer_get_all_elements(layer_get_id("OnGround"));
	var groundSprites = array_concat(arr, arr2);
	for(var i=0; i<array_length(groundSprites); i++) {
		var element = groundSprites[i];
		if(layer_get_element_type(element) == layerelementtype_sprite) {
			var xx = layer_sprite_get_x(element);
			var yy = layer_sprite_get_y(element);
			if(distanceBetweenPoints(x, y, xx, yy) <= radius) {
				layer_sprite_destroy(element);
				layer_sprite_create(sprLay, xx, yy, spr_grass);
			}
		}
		else if(layer_get_element_type(element) == layerelementtype_instance) {
			var inst = layer_instance_get_instance(element);
			if(distanceBetweenPoints(x, y, inst.x, inst.y) <= radius) {
				layer_sprite_create(sprLay, inst.x, inst.y, spr_grass);
				instance_destroy(inst);
			}
		}
	}
}