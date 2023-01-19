if(instance_exists(obj_game) && obj_game.gamePaused || obj_player.inDialogue) return;
var moveLeft = obj_player.x < x;
var moveRight = obj_player.x > x;
var vertMovement = sign(y-obj_player.y);
var distToPlayer = distanceBetweenPoints(x, y, obj_player.x, obj_player.y);
//Horizontal movement
{
	jumpCooldown--;
	if(instance_exists(obj_player) && abs(obj_player.x - x) > 1 && distToPlayer <= 500) {
		if(jumpCooldown <= 0 && distToPlayer <= 200 && random_range(0, 100) <= 1) {
			lungeForward = true;
			hsp = random_range(7, 10) * sign(obj_player.x - x);
			vsp = -3;
			jumpCooldown = room_speed*3;
		}
		if(isHurt) {
			//Cause knockback effect when hit
			hsp *= 0.9;
			vsp *= 0.9
			if(abs(hsp) < 1) {
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
}

//Vertical movement
{
	vsp = hspWalk * vertMovement;
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
			wallCrawling = true;
			var temp = -hspWalk*sign(obj_player.y-y);
			if(place_free(x, y+temp)) y  += temp;
		}
		else
			wallCrawling = false;
		x += hsp;
	}
	
	{//Vertical
		if(!place_free(x, y+vsp)) {
			var temp = 0;
			while(place_free(x, y)) {
				y += sign(vsp);
				temp++;
				if(temp > 50) 
					break;
			}
			temp = 0;
			while(!place_free(x, y)) {
				y -= sign(vsp);
				temp++;
				if(temp > 50) 
					break;
			}
			vsp = 0;
		}
		y += vsp;
	}
}

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

if(y > room_height)
	instance_destroy();