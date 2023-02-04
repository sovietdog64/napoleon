if(enemyDamage)
	return;
for(var i=0; i<array_length(enemiesCollided); i++) {
	if(enemiesCollided[i] == other)
		return;
}

pierce--;
if(pierce <= 0)
	instance_destroy();
	
damageEntity(other, damageSourceInst, damage, 10);
array_push(enemiesCollided, other);