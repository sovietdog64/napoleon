knockbackTime--;
attackCooldown--;
if(state == states.DEAD) {
	calcEntityMovement();
	return;
}

//setting states
var distToPlayer = distance_to_object(obj_player);
if(knockbackTime > 0) //if getting knocked back, then enemy state is hurt
	state = states.HURT;
else if(distToPlayer <= attackDist) //attack if in range
	state = states.ATTACK;
else if(attackCooldown > 0) //if already attacked recently, back away for a bit
	state = states.ATTACKED;
else if(distToPlayer > detectionRange) //if player not in range, go idle
	state = states.IDLE;
else if(distToPlayer <= detectionRange) //if in range, then move
	state = states.MOVE;
//might add more else-ifs here

//handling states
switch(state) {
	case states.HURT: //if hurt, do knockback.
		calcEntityMovement();
	break;
	case states.ATTACK:
		attackCooldown = maxAtkCooldown;
		state = states.ATTACKED;
	break;
}