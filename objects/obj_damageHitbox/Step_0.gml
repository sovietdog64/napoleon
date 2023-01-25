///@description Enemy/player collisions
//Deleting object if didn't collide within life span
if(!lifeSpanSameAsInst) {
	if(lifeSpan > 0)lifeSpan--;
	else instance_destroy();
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
		inst.isHurt = true;
		inst.hsp = -15 * sign(inst.sprite_width);
		inst.vsp = -5;
		inst.hp -= damage;
		inst.knockBack(x, y, knockbackSpeed);
		
		//Screen shake
		if(instance_exists(obj_camera))
			obj_camera.screenShake(scrnShakeDur, scrnShakeLevel);
		
		array_push(enemiesHit, inst);
	}
}