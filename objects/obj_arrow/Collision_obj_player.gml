if(!fromEnemy)
	return;

global.hp -= damage;
audio_play_sound(hitHurt,0,0);
obj_player.knockBack(x,y, 5);
instance_destroy();