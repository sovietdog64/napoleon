//Death
if(hp <= 0) {
	instance_destroy();
	global.xp += xpDrop;
}

if(!instance_exists(obj_player))
	return;
var distToPlayer = distance_to_point(obj_player.x, obj_player.y);

if(distToPlayer <= 300 && !lungeForward) {
	lungeForward = true;
	var dir = point_direction(x, y, obj_player.x, obj_player.y) + random_range(-40, 40);
	hsp = lengthdir_x(25, dir);
	vsp = lengthdir_y(25, dir);
}

if(timeSinceFoundPlayer < room_speed*5)
	timeSinceFoundPlayer++;
else {
	//Retreat to spawn location if didnt find player in 5 sec period
	timeSinceFoundPlayer = 0;
	resetPath(spawnLocX, spawnLocY);
	return;
}
if(instance_exists(obj_game) && global.gamePaused || obj_player.inDialogue || distToPlayer > detectionRange && (targX != spawnLocX && targY != spawnLocY)) {
	path_end();
	return;
}
else if(path_index == -1) {
	timeSinceFoundPlayer = 0;
	resetPath();
}

if(!instance_exists(obj_player))
	return;

timeSinceFoundPlayer = 0;
//movement
{
	//If reached destination, get new path
	if(distance_to_point(targX, targY) <= 10 || distToPlayer <= 200) {
		path_end();
		resetPath();
	}
	if(isHurt) {
		path_end();
		//Cause knockback effect when hit
		hsp *= 0.9;
		vsp *= 0.9;
		if(abs(hsp) < 1 && abs(vsp) < 1) {
			isHurt = false;
			hsp = 0;
			vsp = 0;
			resetPath();
		}
	}
	else if(lungeForward) {
		path_end();
		hsp *= 0.9;
		vsp *= 0.9;
		if(abs(hsp) < 1) {
			lungeForward = false;
			hsp = 0;
			vsp = 0;
			resetPath();
		}
	}
}

//Collision
if(isHurt || lungeForward || path_index == -1) {
	{//Horizontal
		if(!place_free(x+hsp, y)) {
			while(place_free(x, y)) {
				x += sign(hsp);
			}
			if(hsp == 0)
				hsp = choose(-1,1);
			while(!place_free(x, y)) {
				x -= sign(hsp);
			}
			hsp = 0;
		}
		x += hsp;
	}
	
	{//Vertical
		if(!place_free(x, y+vsp)) {
			while(place_free(x, y)) {
				y += sign(vsp);
			}
			while(!place_free(x, y)) {
				y -= sign(vsp);
			}
			vsp = 0;
		}
		y += vsp;
	}
}

//Prevent from going off-screen
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);
	
saveEnemy = false;