with(obj_mouse) {
	with(instance_create_layer(obj_player.x, obj_player.y, obj_player.layer, obj_item)) {
		item = duplicateItem(other.itemDrag);
	}
	itemDrag = -1;
}

if(throwOutItems)
	for(var i=0; i<invSize; i++)
		with(instance_create_layer(obj_player.x, obj_player.y, obj_player.layer, obj_item)) {
			item = duplicateItem(other.invArray[i]);
		}