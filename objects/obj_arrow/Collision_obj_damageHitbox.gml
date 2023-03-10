if(other.enemyHit != fromEnemy) {
	if(!other.enemyHit) {
		audio_play_sound(parry,0,0)
		instance_destroy();
	}
}