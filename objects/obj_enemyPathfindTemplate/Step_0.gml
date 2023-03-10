knockbackTime--;
attackCooldown--;
if(state == states.DEAD) {
	instance_destroy();
	return;
}

//setting states
var distToPlayer = distance_to_object(obj_player);

//handling states
switch(state) {
	case states.HURT: { //if hurt, do knockback.
		calcEntityMovement();
		if(knockbackTime <= 0) // set to move after no more knockback
			state = states.MOVE;
		return;
	}break;
	
	case states.MOVE: {
		if(distToPlayer <= attackDist)
			state = states.ATTACK;
		else if(distToPlayer > detectionRange)
			state = states.IDLE;
		
		if(knockbackTime > 0) //check for being hurt when moving
			state = states.HURT;
		
	}break;
	
	case states.ATTACK:{
		attackCooldown = maxAtkCooldown;
		var dir = point_direction(x, y, obj_player.x, obj_player.y);
		var len = attackDist*0.3;
		var xx = lengthdir_x(len, dir);
		var yy = lengthdir_y(len, dir);
		damageHitbox(
			x+xx, y+yy,
			24,24,
			targX,targY,
			1,
			10, 10,
			true,
			true,
			false,
			xx,yy
		).sprite_index = spr_stab;
		state = states.ATTACKED;
	}break;
	
	case states.ATTACKED: {
		if(attackCooldown <= 0)
			state = states.MOVE;
		
		if(knockbackTime > 0) //check for being hurt when moving
			state = states.HURT;
	}break;
		
	case states.IDLE: {
		if(distToPlayer <= detectionRange)
			state = states.MOVE;
	}
}

if(obj_player.state == PlayerStateLocked)
	path_end();

if(pathFailed) {
	var dir = point_direction(x, y, obj_player.x, obj_player.y);
	var len = walkSpd;
	hsp = lengthdir_x(len, dir);
	vsp = lengthdir_y(len, dir);
	calcEntityMovement(false);
}