function doAction() {
	if(place_meeting(x, y, obj_player)) {
		//Block off exit
		var inst = instance_create_layer(768, 1440, "Collision", obj_solid);
		inst.image_xscale = 8;
		instance_destroy();
	}
}