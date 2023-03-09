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
		instance_create_depth(x,y,0,obj_arrow, {
			damage : 1,
			speed : 7,
			fromEnemy : true,
			direction : point_direction(x,y, obj_player.x,obj_player.y),
		})
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

if(global.gamePaused || obj_player.state == PlayerStateLocked)
	path_end();

if(pathFailed) {
	var dir = point_direction(x, y, obj_player.x, obj_player.y);
	var len = walkSpd;
	hsp = lengthdir_x(len, dir);
	vsp = lengthdir_y(len, dir);
	calcEntityMovement(false);
}