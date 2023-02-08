///@description Enemy/player collisions
//Deleting object if didn't collide within life span
if(!lifeSpanSameAsInst) {
	if(lifeSpan > 0)
		lifeSpan--;
	else {
		instance_destroy();
		return;
	}
}
else {
	if(!instance_exists(instToFollow)) {
		instance_destroy();
		return;
	}
}

if(instToFollow != noone) {
	x = instToFollow.x + followOffsetX;
	y = instToFollow.y + followOffsetY;
}	

//Enemies
if(!enemyHit && !dontHit) {
	var enemies = ds_list_create();
	instance_place_list(x, y, obj_enemy, enemies, 0);
	if(ds_list_size(enemies) > 0) {
		for(var i=0; i<ds_list_size(enemies); i++){
			//prevent hitting same enemy twice
			var alreadyHit = false;
			for(var j=0; j<array_length(enemiesHit); j++) {
				if(ds_list_find_value(enemies, i) == enemiesHit[j]) {
					alreadyHit = true;
					break;
				}
			}
			if(alreadyHit)
				continue;
			//If new enemy, do a hit
			var inst = ds_list_find_value(enemies, i);
			damageEntity(inst, dmgSourceInst, damage, knockbackDur);
		
			screenShake(scrnShakeDur, scrnShakeLevel);
		
			array_push(enemiesHit, inst);
		}
	}
}
else if (enemyHit){
	if(place_meeting(x, y, obj_player) && !dontHit && obj_player.hurtCooldown <= 0) {
		dontHit = true;
		obj_player.hurtCooldown = obj_player.maxHurtCooldown;
		global.hp--;
		obj_player.knockBack(x, y, knockbackDur);
	}
}