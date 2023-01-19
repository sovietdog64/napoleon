if(isHurt || hurtCooldown > 0)
	return;
isHurt = true;
hurtCooldown = room_speed*1;
global.hp--;
var dir = point_direction(x, y, other.x, other.y);
hsp = 40*dsin(dir);
vsp = -40*dcos(dir);