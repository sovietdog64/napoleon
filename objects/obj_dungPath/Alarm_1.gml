#region ground
var pathAngle = point_direction(0,0, dirVec.x, dirVec.y);
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
