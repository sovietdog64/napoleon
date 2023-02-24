///@description spawn new goblins every 10s
for(var i=0; i<array_length(goblins); i++) {
	var goblin = goblins[i];
	if(goblin.state == states.DEAD || !instance_exists(goblin)) {
		var p = randPointInCircle(radius);
		var inst =  instance_create_layer(x+p.x, y+p.y, "Instances", obj_goblin);
		goblins[i] = inst;
	}
}