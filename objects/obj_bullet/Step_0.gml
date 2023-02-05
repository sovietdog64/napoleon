image_angle = direction;
if(!place_free(x, y))
	instance_destroy();
if(pierce < 0)
	instance_destroy();
	
var enemy = collision_line(x, y, xprevious, yprevious, obj_enemy, 0, 0);
var player = collision_line(x, y, xprevious, yprevious, obj_player, 0, 0);
show_debug_message(enemy)
if(!enemyDamage && enemy != noone && enemy.state != states.DEAD)
	damageEnemy(enemy);
else if(enemyDamage && player != noone)
	damagePlayer();