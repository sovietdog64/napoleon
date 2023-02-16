if(hp <= 0) {
	var f = function(_element, _index) {
		var item = instance_create_layer(x, y, layer, obj_item);
		item.item = _element;
	}
	array_foreach(resourceDrops, f);
	instance_destroy();
}