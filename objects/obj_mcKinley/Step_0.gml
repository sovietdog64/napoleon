attackCooldown--;
if(state == states.DEAD) {
	path_end();
	calcEntityMovement();
	deadTime++;
	if(deadTime > room_speed*5) {
		instance_destroy();
	}
	return;
}
switch(state) {
	case states.IDLE:
		calcEntityMovement();
		checkForPlayer();
		if(path_index != -1)
			state = states.MOVE;
	break;
	case states.MOVE:
		calcEntityMovement();
		checkForPlayer();
		if(path_index == -1)
			state = states.IDLE;
	break;
	case states.ATTACK:
		calcEntityMovement();
	break;
	case states.DEAD:
		
	break;
}

var distToPlayer = 0;
if(instance_exists(obj_player))
	distToPlayer = distance_to_object(obj_player);
if(state == states.ATTACK) {
	if(distToPlayer <= attackDist) {
		
	}
}