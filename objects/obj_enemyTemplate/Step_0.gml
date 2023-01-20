if(instance_exists(obj_game) && obj_game.gamePaused || obj_player.inDialogue) return;
var moveLeft = obj_player.x < x;
var moveRight = obj_player.x > x;
var vertMovement = sign(y-obj_player.y);
var distToPlayer = distanceBetweenPoints(x, y, obj_player.x, obj_player.y);
//Horizontal movement
{
	jumpCooldown--;
	if(instance_exists(obj_player) && abs(obj_player.x - x) > 30 && distToPlayer <= 500) {
		if(jumpCooldown <= 0 && distToPlayer <= 200 && random_range(0, 100) <= 1) {
			lungeForward = true;
			hsp = random_range(7, 10) * sign(obj_player.x - x);
			vsp = -3;
			jumpCooldown = room_speed*3;
		}
		if(isHurt) {
			//Cause knockback effect when hit
			hsp *= 0.9;
			vsp *= 0.9;
			if(abs(hsp) < 1 && abs(vsp) < 1) {
				isHurt = false;
				hsp = 0;
				vsp = 0;
			}
		}
		else if(lungeForward) {
			hsp *= 0.9;
			vsp *= 0.9;
			if(abs(hsp) < 1) {
				lungeForward = false;
				hsp = 0;
				vsp = 0;
			}
		}
		else {
			//Judge horizontal direciton of movement depending on player position.
			hsp = (moveLeft-moveRight)*hspWalk;

			if(hsp < 0) {image_xscale = -1;}
			else if(hsp > 0) {image_xscale = 1;}
		}
	}
	else
		hsp = 0
}

//Vertical movement
{
	if(abs(y-obj_player.y) > 10)
		vsp = hspWalk * vertMovement;
	else
		vsp = 0;
}

{//Collision
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