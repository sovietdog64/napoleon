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
		calcEntityMovement();
		instance_destroy();
	break;
}