function boxingGloveAttack(targX, targY, hitboxDuration) {
	leftAttackCooldown = room_speed*0.21;
	var dir = point_direction(x, y, targX, targY);
	//Calculate the direction of the punch hitbox
	var xx = x + (50*dcos(dir));
	var yy = y + (-50*dsin(dir));
				
	sprite_index = choose(spr_playerPunchLeft, spr_playerPunchRight);
	//Create dmg hitbox (hitboxes are more resource efficient compared to individial enemy collision checks)
	var inst = instance_create_layer(x+xx, y+yy, "Instances", obj_damageHitbox);
	inst.dmgSourceInst = id;
	inst.enemyHit = false;
	inst.instToFollow = id;
	inst.followOffsetX = xx-x;
	inst.followOffsetY = yy-y;
	inst.damage = 1;
	inst.lifeSpan = hitboxDuration;
	inst.image_angle = dir;
	inst.sprite_index = spr_boxingEffect;
	
	lungeForward = true;
	hsp = (xx-x)/5;
	vsp = (yy-y)/5;
	if(hsp < 0) {image_xscale = -1; direction = 180;}
	else if(hsp> 0) {image_xscale = 1; direction = 0;}
}

function tantoStab(targX, targY, hitboxDuration) {
	leftAttackCooldown = room_speed*0.21;
	var dir = point_direction(x, y, targX, targY);
	//Calculate the direction of the punch hitbox
	var xx = x + (50*dcos(dir));
	var yy = y + (-50*dsin(dir));
	
	//Create dmg hitbox (hitboxes are more resource efficient compared to individial enemy collision checks)
	var inst = instance_create_layer(x+xx, y+yy, "Instances", obj_damageHitbox);
	inst.enemyHit = false;
	inst.instToFollow = id;
	inst.followOffsetX = xx-x;
	inst.followOffsetY = yy-y;
	inst.damage = 3;
	inst.lifeSpan = hitboxDuration;
	inst.image_angle = dir;
	inst.sprite_index = spr_tantoStab;
	
	lungeForward = true;
	hsp = (xx-x)/5;
	vsp = (yy-y)/5;
	if(hsp < 0) {image_xscale = -1; direction = 180;}
	else if(hsp> 0) {image_xscale = 1; direction = 0;}
}

function tantoSlash(targX, targY, hitboxDuration) {
	leftAttackCooldown = room_speed*0.5;
	var dir = point_direction(x, y, targX, targY);
	//Calculate the direction of the punch hitbox
	var xx = x + (50*dcos(dir));
	var yy = y + (-50*dsin(dir));
	
	//Create dmg hitbox (hitboxes are more resource efficient compared to individial enemy collision checks)
	var inst = instance_create_layer(x+xx, y+yy, "Instances", obj_damageHitbox);
	inst.enemyHit = false;
	inst.instToFollow = id;
	inst.followOffsetX = (xx-x);
	inst.followOffsetY = (yy-y);
	inst.damage = 5;
	inst.lifeSpan = hitboxDuration;
	inst.knockbackDur = 40;
	inst.image_xscale = 1.5;
	inst.image_yscale = 1.5;
	inst.sprite_index = spr_npc;
	
	lungeForward = true;
	hsp = (xx-x)/2;
	vsp = (yy-y)/2;
	if(hsp < 0) {image_xscale = -1; direction = 180;}
	else if(hsp> 0) {image_xscale = 1; direction = 0;}
}