//if opposing damage sources, cancel out damage
if(other.enemyHit != enemyHit && random_range(0, 100) <= 50) {
	dontHit = true;
	other.dontHit = true;
}