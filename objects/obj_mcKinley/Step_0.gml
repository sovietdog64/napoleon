#region attacks/actions
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
//Handle attacking states
var dist = distance_to_object(obj_player);
if(dist <= attackDist) {
	attackState = attackStates.MELEE;
	shootCooldown = room_speed*3;
}
else if(dist <= 800 && dist > attackDist)
	attackState = attackStates.SHOOT;
else if(dist > 800)
	attackState = attackStates.NONE;

shootCooldown--;

if(attackState == attackStates.MELEE && attackCooldown <= 0) {
	attackCooldown = maxAttackCooldown;
	var inst = instance_create_layer(x, y, layer, obj_damageHitbox);
	inst.enemyHit = true;
	inst.instToFollow = id;
	inst.dmgSourceInst = id;
	var dir = point_direction(x, y, obj_player.x, obj_player.y);
	inst.followOffsetX = lengthdir_x(sprite_width, dir);
	inst.followOffsetY = lengthdir_y(sprite_width, dir);
	inst.sprite_index = spr_npc;
}
else if(attackState == attackStates.SHOOT && shootCooldown <= 0) {
	shootCooldown = itemDrops[0].cooldown;
	var firedBullet = fireBullet(x, y, obj_player.x, obj_player.y, itemDrops[0], true, 30);
	if(!firedBullet) {
		var inst = placeSequenceAnimation(x, y, itemDrops[0].reloadSeq);
		array_push(followingSequences, inst);
		shootCooldown = itemDrops[0].reloadDuration+2;
		attackState = attackStates.RELOAD;
	}
}


show_debug_message(shootCooldown);

for(var i=0; i<array_length(followingSequences); i++) {
	var seq = followingSequences[i]
	if(!layer_sequence_exists("Animations", seq)) {
		array_delete(followingSequences, i, 1);
		continue;
	}
	if(layer_sequence_is_finished(seq)) {
		layer_sequence_destroy(seq);
		itemDrops[0].currentAmmoAmount = 30;
		attackState = attackStates.NONE;
		continue;
	}
	layer_sequence_x(seq, x);
	layer_sequence_y(seq, y);
}
#endregion attacks/actions

#region animations
//Facing direction
if(state != states.DEAD) {
	image_xscale = sign(obj_player.x - x);
	image_xscale = clamp(image_xscale, -1, 1);
}
#endregion animations