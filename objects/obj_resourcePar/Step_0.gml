if(hp <= 0) {
	for(var i=0; i<array_length(resourceDrops); i++) {
		with(instance_create_depth(x, y, depth, obj_item)) {
			item = other.resourceDrops[i];
		}
	}
	
	instance_destroy();
}