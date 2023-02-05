 spd = 20;
spd *= 3;
motion_set(direction, spd);
pierce = 0; //Amount of enemies can pierce
damage = 1;
enemyDamage = false;
damageSourceInst = obj_player;
knockBack = 10;

enemiesCollided = array_create(0);

damageEnemy = function(enemy) {
	if(enemyDamage)
		return;
	if(enemy.state == states.DEAD)
		return;
	for(var i=0; i<array_length(enemiesCollided); i++) {
		if(enemiesCollided[i] == enemy)
			return;
	}

	pierce--;
	if(pierce <= 0)
		instance_destroy();
	
	damageEntity(enemy, damageSourceInst, damage, 10);
	array_push(enemiesCollided, enemy);
}

damagePlayer = function() {
	global.hp--;
	instance_destroy();
}