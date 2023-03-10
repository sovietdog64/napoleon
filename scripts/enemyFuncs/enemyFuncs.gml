function calcEntityMovement(drag = true) {
	path_end();
	//Collision
	{
		{//Horizontal
			if(!place_free(x+hsp, y) && hsp != 0) {
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
			if(!place_free(x, y+vsp) && vsp != 0) {
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
	if(drag) {
		hsp *= global.drag;
		vsp *= global.drag;
	}
	
	checkIfStopped();
}

function checkIfStopped() {
	if abs(hsp) < 0.1
		hsp = 0;
	if abs(vsp) < 0.1
		vsp = 0;
}

function checkForPlayer() {
	if(!instance_exists(obj_player))
		return 0;
	if(global.gamePaused || obj_player.state = PlayerStateLocked)
		return 0;
	var dist = distance_to_object(obj_player);
	//If not close enought o enemy and not close enough to attack
	if((dist <= detectionRange) || alert) && dist > attackDist {
		alert = true;
		var foundPlayer = mp_grid_path(grid, path, x, y, obj_player.x, obj_player.y, 1);
	
		if(foundPlayer) {
			path_start(path, walkSpd, path_action_stop, 0);
		}
	}
	//If close enough to attack
	else if (dist <= attackDist){
		state = states.ATTACK;
		path_end();
	}
		
	return 1;
}
	
function damageEntity(targetId, dmgSourceId, dmg, time) {
	if(targetId.state == states.DEAD)
		return;
	with(targetId) {
		path_end();
		hp -= dmg;
		var dead = is_dead();
		
		if(dead)
			var dis = 15;
		else
			var dis = 10;
			
		var dir = point_direction(dmgSourceId.x, dmgSourceId.y, x, y);
		hsp = lengthdir_x(dis, dir);
		vsp = lengthdir_y(dis, dir);
		knockbackTime = time;
		return dead;
	}
}

function is_dead() {
	if(state == states.DEAD)
		return 0;
	if(hp <= 0) {
		state = states.DEAD;
		hp = 0;
		image_index = 0;
		switch(object_index) {
			default:
				//play death snd
			break;
			
			case obj_player:
				//play death snd
			break;
		}
		if(variable_instance_exists(id, "xpDrop"))
			global.xp += xpDrop;
		if(variable_instance_exists(id, "itemDrops")) {
			for(var i=0; i<array_length(itemDrops); i++) {
				dropItem(itemDrops[i], x, y);
			}
		}
		return 1;
	}
}

function enemyAnimate() {
	//TODO: add inst vars containing all animation sprite indexes & update this func to work
	switch(state) {
		case states.IDLE:
			
		break;
		case states.MOVE:
			
		break;
		case states.ATTACK:
			
		break;
		case states.DEAD:
			
		break;
	}
}