/// @description Making ground/doors/walls/paths

#region ground

ground = layer_sprite_create(
	layer_get_id("Ground"),
	x+TILEW, y+TILEW,
	spr_dungFloor
)

layer_sprite_xscale(
	ground,
	(rmWidth-TILEW-TILEW)/sprite_get_width(spr_dungFloor)
)

layer_sprite_yscale(
	ground,
	(rmHeight-TILEW-TILEW)/sprite_get_height(spr_dungFloor)
)

#endregion ground

#region doors & paths

for(var i=0; i<array_length(bridgedTo); i++) {
	//Getting the doors down
	
	//get vector that represents the direction of the door. (var diff)
	var rmMapPos = mapPos.copy();
	var diff = bridgedTo[i].mapPos.copy();
	diff.subtractVec(rmMapPos);
	diff.normalize();
	var doorDirVec = diff.copy();
	
	//making sure that the door isnt out of room bounds.
	doorDirVec.x *= (rmWidth/2);
	if(doorDirVec.x > 0)
		doorDirVec.x -= TILEW;
	
	doorDirVec.y *= (rmHeight/2);
	if(doorDirVec.y > 0)
		doorDirVec.y -= TILEW;
	
	//Get door position relative to center of room/room cell
	var doorPos = new Vector2(cellMid.x, cellMid.y);
	doorPos.addVec(doorDirVec);
	
	var door = instance_create_layer(doorPos.x, doorPos.y, "Ground", obj_dungeonDoor);
	
	if(doorDirVec.x != 0)
		door.sprite_index = spr_dungDoorVert;
		
	
	//If bridge to this room was already built, move on.
	if(array_contains(bridgedTo[i].buildedBridgeTo, id))
		continue;
	
	//Place path
	var path = instance_create_layer(
		door.x+diff.x, door.y+diff.y,
		"Ground",
		obj_dungPath,
		{
			dirVec : diff.copy(),
			creatorID : creatorID,
			mapPos : mapPos,
			pathWidth : TILEW*3
		});
	
	array_push(buildedBridgeTo, bridgedTo[i]);
}

#endregion doors & paths

#region walls

//walls on left and right of room
for(var i=0; i<2; i++) {
	var wall = instance_create_layer(
		x+(rmWidth-TILEW)*i, y,
		"OnGround",
		obj_solid
	)
	
	wall.sprite_index = spr_dungWall;
	wall.image_yscale = rmHeight/TILEW;
	
	var make2ndWall = false;
	
	var door;
	
	//Checking if there is a door colliding with the wall.
	//If there is one, then shorten the wall to the door, and then extend it--starting from the bottom of the door.
	with(wall) {
		//If door inside the wall, then shorten wall up to the door.
		door = instance_place(x, y, obj_dungeonDoor);
		if(door != noone)  {
			image_yscale = (door.bbox_top-y)/TILEW;
			make2ndWall = true;
		}
		
	}
		
	if(make2ndWall) {
		var wall2 = instance_create_layer(
			wall.x, door.bbox_bottom,
			"OnGround",
			obj_solid
		)
		wall2.sprite_index = spr_dungWall;
		wall2.image_yscale = (y+rmHeight - wall2.y)/TILEW;
	}
}

//walls on top and bottom of room
for(var i=0; i<2; i++) {
	var wall = instance_create_layer(
		x, y+(rmHeight-TILEW)*i,
		"OnGround",
		obj_solid
	)
	wall.sprite_index = spr_dungWall;
	wall.image_xscale = (rmWidth/TILEW);
	
	var make2ndWall = false;
	
	var door;
	
	//Checking if there is a door colliding with the wall.
	//If there is one, then shorten the wall to the door, and then extend it--starting from the bottom of the door.
	with(wall) {
		//If door inside the wall, then shorten wall up to the door.
		door = instance_place(x, y, obj_dungeonDoor);
		if(door != noone)  {
			image_xscale = (door.bbox_left - x)/TILEW;
			make2ndWall = true;
		}
	}
		
	if(make2ndWall) {
		var wall2 = instance_create_layer(
			door.bbox_right, wall.y ,
			"OnGround",
			obj_solid
		)
		wall2.sprite_index = spr_dungWall;
		wall2.image_xscale = (x+rmWidth - wall2.x)/TILEW;
	}
}
	
#endregion walls