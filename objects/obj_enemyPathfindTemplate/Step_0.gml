var distToPlayer = distance_to_point(obj_player.x, obj_player.y);
if(timeSinceFoundPlayer < room_speed*5)
	timeSinceFoundPlayer++;
else {
	timeSinceFoundPlayer = 0;
	resetPath(spawnLocX, spawnLocY);
	return;
}
if(instance_exists(obj_game) && obj_game.gamePaused || obj_player.inDialogue || distToPlayer > detectionRange && (targX != spawnLocX && targY != spawnLocY)) {
	path_end();
	return;
}
else if(path_index = -1) {
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


if(path_index == -1){//Collision
	{//Horizontal
		if(!place_free(x+hsp, y)) {
			while(place_free(x, y)) {
				x += sign(hsp);
			}
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

//Spider death
if(hp <= 0) {
	instance_destroy();
	global.xp += xpDrop;
	for(var i=0; i<array_length(global.activeQuests); i++) {
		var quest = global.activeQuests[i];
		if(quest.questName != "Spider Slayer") 
			return;
		if(quest.progress < 1) {
			quest.kills++;
			quest.progress = quest.kills/quest.maxKills;
		}
	}
}