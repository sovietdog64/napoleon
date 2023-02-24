/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

goblins = [];

repeat(irandom_range(1, 4))
	array_push(goblins, instance_create_layer(x, y, "Instances", obj_goblin))