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
	case states.ATTACK: {
		calcEntityMovement();
	} break;
	case states.DEAD:
		
	break;
}
var distToPlayer = -1;
if(instance_exists(obj_player))
	distToPlayer = distance_to_object(obj_player);
//if player doesn't exist, do nothing
if(distToPlayer == -1) {}
else if(distToPlayer <= attackDist) {//Pull out knife if near
	equipped = knife;
}
//Use gun if player in range & in sight
else if(distToPlayer <= detectionRange && collision_line(x, y, obj_player.x, obj_player.y, obj_solid, 0, 1) == noone) {
	equipped = itemDrops[0];
}

attackCooldown--;

if(equipped == knife && attackCooldown <= 0) {
	attackCooldown = room_speed*0.8;
	var dir = point_direction(x, y, obj_player.x, obj_player.y);
	var len = sprite_width;
	var hb = instance_create_layer(x, y, layer, obj_damageHitbox);
	hb.enemyHit = true;
	hb.instToFollow = id;
	hb.dmgSourceInst = id;
	hb.followOffsetX = lengthdir_x(len, dir);
	hb.followOffsetY = lengthdir_y(len, dir);
	hb.sprite_index = spr_npc;
	hb.lifeSpan = 10;
}
else if(equipped == itemDrops[0] && attackCooldown <= 0) {
	attackCooldown = equipped.cooldown;
	var firedBullet = fireBullet(x, y, obj_player.x, obj_player.y, equipped, true, 30);
	if(!firedBullet) {
		//do reload
		attackCooldown = equipped.reloadDuration;
	}
}