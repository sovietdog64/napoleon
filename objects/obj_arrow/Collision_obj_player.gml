if(!fromEnemy)
	return;

global.hp -= damage;
obj_player.knockBack(x,y, 5);
instance_destroy();