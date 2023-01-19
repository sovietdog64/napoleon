if(enemyDamage) 
	return;
if(sprite_index == spr_musketBallProj) {
	other.hp -= damage;
}
pierce--;
if(pierce < 0)
	instance_destroy();