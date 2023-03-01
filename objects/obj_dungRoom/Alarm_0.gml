/// @description Making doors/walls

#region doors

for(var i=0; i<array_length(bridgedTo); i++) {
	var rmMapPos = mapPos.copy();
	var diff = bridgedTo[i].mapPos.copy();
	diff.subtractVec(rmMapPos);
	diff.normalize();
	
	diff.x *= rmWidth/2;
	diff.y *= rmHeight/2;
	
	var doorPos = new Vector2(cellMid.x, cellMid.y);
	doorPos.addVec(diff);
	
	instance_create_layer(doorPos.x, doorPos.y, "OnGround",obj_dungeonDoor);
	
}

#endregion doors


return;
#region walls

for(var i=0; i<2; i++) {
	var wall = instance_create_layer(
		x+(rmWidth-TILEW)*i, y,
		"OnGround",
		obj_solid
	)
	wall.sprite_index = spr_dungWall;
	wall.image_yscale = (rmHeight/TILEW);
}

for(var i=0; i<2; i++) {
	var wall = instance_create_layer(
		x, y+(rmHeight-TILEW)*i,
		"OnGround",
		obj_solid
	)
	wall.sprite_index = spr_dungWall;
	wall.image_xscale = (rmWidth/TILEW);
}
	
#endregion walls