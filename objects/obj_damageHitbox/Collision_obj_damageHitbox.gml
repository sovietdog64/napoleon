//if opposing damage sources, cancel out damage (30% chance)
if(!dontHit && other.enemyHit != enemyHit && random_range(0, 100) <= 30) {
	if(enemyHit) {
		dontHit = true;
		audio_play_sound(parry,0,0);
	}
	other.dontHit = true;
}