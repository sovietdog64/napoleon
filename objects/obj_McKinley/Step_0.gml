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
		if(distance_to_object(obj_player) <= sprite_width)
			attackState = attackStates.MELEE;
		if(attackState == attackStates.MELEE && attackCooldown <= 0) {
			attackCooldown = maxAttackCooldown;
			var inst = instance_create_layer(x, y, layer, obj_damageHitbox);
			inst.enemyHit = true;
			inst.instToFollow = id;
			inst.dmgSourceInst = id;
			var dir = point_direction(x, y, obj_player.x, obj_player.y);
			inst.followOffsetX = lengthdir_x(sprite_width/2, dir);
			inst.followOffsetY = lengthdir_y(sprite_width/2, dir);
			inst.sprite_index = spr_npc;
		}
	break;
	case states.DEAD:
		
	break;
}

//Toggling attack mode from shooting and none
if(shootCooldown > 0)
	shootCooldown--;
else if (shootCooldown <= 0){
	if(attackState == attackStates.SHOOT) {
		attackState = attackStates.NONE;
		shootCooldown = room_speed*10;
	}
	else {
		attackState = attackStates.SHOOT;
		shootCooldown = room_speed*5;
	}
}