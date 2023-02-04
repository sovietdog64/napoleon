attackCooldown--;
sprintCd--;
if(sprintCd <= 0) {
	isSprinting = !isSprinting;
	if(isSprinting)
		hspWalk = sprintSpd;
	else
		hspWalk = hspWalkRegular;
	sprintCd = room_speed*5
}
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