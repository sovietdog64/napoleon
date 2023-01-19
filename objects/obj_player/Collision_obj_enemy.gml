if(isHurt) return;
isHurt = true;
global.hp--;
var dir = point_direction(x, y, other.x, other.y)-180;
if(dir >= 90 && dir <= 270) {
	hsp = -30;
	vsp = -10;
} else {
	hsp = 30;
	vsp = -10;
}