//if opposing damage sources, cancel out damage
if(other.enemyHit != enemyHit) {
	dontHit = true;
	other.dontHit = true;
}