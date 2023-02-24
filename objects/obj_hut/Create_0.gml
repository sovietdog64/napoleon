/// @description Spawning initial goblins
// You can write your code in this editor

// Inherit the parent event
event_inherited();

radius = sprite_width;
if(sprite_height > radius)
	radius = sprite_height;

goblins = [];

repeat(irandom_range(1, 4)) {
	var p = randPointInCircle(radius);
	var inst =  instance_create_layer(x+p.x, y+p.y, "Instances", obj_goblin);
	array_push(goblins, inst)
}
	
alarm_set(0, room_speed*10);