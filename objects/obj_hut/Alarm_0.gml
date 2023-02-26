///@description spawn new goblins every 10s
for(var i=0; i<array_length(goblins); i++) {
	var goblin = goblins[i];
	if(!instance_exists(goblin) || goblin.state == states.DEAD) {
		var len = irandom_range(
			radius+sprite_get_height(spr_goblin),
			radius*1.5+sprite_get_height(spr_goblin)
		);
		var dir = irandom(360);
		var inst =  instance_create_layer(
			x+lengthdir_x(len, dir), y+lengthdir_y(len, dir),
			"Instances", obj_goblin
		);
		goblins[i] = inst;
	}
}

alarm_set(0, room_speed*10)