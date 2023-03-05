/// @description Spawning initial goblins
if(variable_instance_exists(id, "noCreateEvent") && noCreateEvent) {
	noCreateEvent = false;
	return;
}
// Inherit the parent event
event_inherited();

radius = sprite_width;
if(sprite_height > radius)
	radius = sprite_height;

goblins = [];

repeat(irandom_range(1, 4)) {
	var len = irandom_range(
		radius+sprite_get_height(spr_goblin),
		radius*1.5+sprite_get_height(spr_goblin)
	);
	var dir = irandom(360);
	var inst =  instance_create_layer(
		x+lengthdir_x(len, dir), y+lengthdir_y(len, dir),
		"Instances", obj_goblin
	);
	with(inst) {
		while(!place_free(x, y)) {
			x += lengthdir_x(len, dir);
			y += lengthdir_y(len, dir);
		}
	}
	array_push(goblins, inst)
}
	
alarm_set(0, room_speed*10);