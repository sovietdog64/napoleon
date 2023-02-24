// Inherit the parent event
event_inherited();

for(var i=0; i<array_length(goblins); i++) {
	var goblin = goblins[i];
	if(instance_exists(goblin))
		continue;
	else {
		array_delete(goblins, i, 1);
		array_push(goblins, instance_create_layer(x, y, "Instances", obj_goblin))
	}
}