for(var i=0; i<array_length(enemiesCollided); i++) {
	if(enemiesCollided[i] == other)
		return;
}

pierce--;
if(pierce <= 0)
	instance_destroy();
	
other.hp -= damage;
array_push(enemiesCollided, other);