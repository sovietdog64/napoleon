//if opposing damage sources, cancel out damage (30% chance)
if(other.enemyHit != enemyHit && random_range(0, 100) <= 30) {
	dontHit = true;
	other.dontHit = true;
}