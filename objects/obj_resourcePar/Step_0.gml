if(hp <= 0) {
	var f = function(_element, _index) {
		with(instance_create_layer(x, y, layer, obj_item)) {
			item = _element;
		}
	}
	array_foreach(resourceDrops, f);
	instance_destroy();
}