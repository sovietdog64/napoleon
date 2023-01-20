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
var hasHitInstance = false;
var enemies = ds_list_create();
instance_place_list(x, y, obj_enemy, enemies, 0);
if(ds_list_size(enemies) > 0) {
	for(var i=0; i<ds_list_size(enemies); i++){
		var inst = ds_list_find_value(enemies, i);
		inst.isHurt = true;
		inst.hsp = -15 * sign(inst.sprite_width);
		inst.vsp = -5;
		inst.hp--;
		inst.knockBack(x, y, knockbackSpeed);
		var hasHitInstance = true;
	}
}

if(!lifeSpanSameAsInst && hasHitInstance) {
	instance_destroy();
}