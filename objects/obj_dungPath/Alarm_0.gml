var targMapPos = mapPos.copy();
targMapPos.addVec(dirVec);

var rm = creatorID.dungeonGrid[# targMapPos.x, targMapPos.y];

//Get path length
len = pointDistToRect(
	rm.x, rm.y,
	rm.x+rm.rmWidth, rm.y+rm.rmHeight,
	x, y
)

#region walls

var wall1 = instance_create_layer(
	x,y,
	"OnGround",
	obj_solid
)
wall1.sprite_index = spr_dungWall;

var wall2 = instance_create_layer(
	x,y,
	"OnGround",
	obj_solid
)
wall2.sprite_index = spr_dungWall;

//placing walls in right direction on the sides of the path.
if(dirVec.x != 0) {
	wall1.image_xscale = len/TILEW*dirVec.x;
	wall1.y += pathWidth/2;
	
	wall2.image_xscale = len/TILEW*dirVec.x;
	wall2.y -= (pathWidth/2)+TILEW;
}
else if(dirVec.y != 0) {
	wall1.image_yscale = len/TILEW*dirVec.y;
	wall1.x += pathWidth/2;
	
	wall2.image_yscale = len/TILEW*dirVec.y;
	wall2.x -= (pathWidth/2)+TILEW;
}

#endregion walls