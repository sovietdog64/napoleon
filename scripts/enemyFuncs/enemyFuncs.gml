function calcEntityMovement() {
	if(!place_free(x+hsp, y+vsp)) {
		hsp = 0;
		vsp = 0;
	}
	x += hsp;
	y += vsp;
	hsp *= global.drag;
	vsp *= global.drag;
	
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
		var foundPlayer = mp_grid_path(grid, path, x, y, obj_player.x, obj_player.y, choose(0, 1));
	
		if(foundPlayer) {
			path_start(path, hspWalk, path_action_stop, 0);
		}
	}
	//If close enough to attack
	else if (dist <= attackDist){
		path_end();
	}
}
	
function damageEntity(targetId, dmgSourceId, dmg, time) {
	with(targetId) {
		hp -= dmg;
		var dead = is_dead();
		
		if(dead)
			var dis = 40;
		else
			var dis = 20;
			
		var dir = point_direction(dmgSourceId.x, dmgSourceId.y, x, y);
		hsp += lengthdir_x(dis, dir);
		vsp += lengthdir_y(dis, dir);
		alert = true;
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