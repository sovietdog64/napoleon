if(variable_instance_exists(id, "noCreateEvent") && noCreateEvent)
	return;
var pathAngle = point_direction(0,0, dirVec.x, dirVec.y);

var targMapPos = mapPos.copy();
targMapPos.addVec(dirVec);

var rm = creatorID.dungeonGrid[# targMapPos.x, targMapPos.y];

//Get path length
var len = pointDistToRect(
	rm.x, rm.y,
	rm.x+rm.rmWidth, rm.y+rm.rmHeight,
	x, y
)

#region ground

var x1 = x-lengthdir_x(pathWidth/2, pathAngle+90)
var y1 = y-lengthdir_y(pathWidth/2, pathAngle+90)
ground = layer_sprite_create(
	layer_get_id("Ground"),
	x1,
	y1,
	spr_dungFloor
)

endX = x+lengthdir_x(len, pathAngle);
endY = y+lengthdir_y(len, pathAngle);

x2 = endX+lengthdir_x(pathWidth/2, pathAngle+90)
y2 = endY+lengthdir_y(pathWidth/2, pathAngle+90)
var w = sprite_get_width(spr_dungFloor);

layer_sprite_xscale(ground, (x2-x1)/w);
layer_sprite_yscale(ground, (y2-y1)/w);

#endregion ground

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