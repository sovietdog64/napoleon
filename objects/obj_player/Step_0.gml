var heldItem = global.hotbarItems[global.equippedItem];
if(inDialogue) {//If in dialogue, do gravity. nothing else
	vsp += grv;
	if(!place_free(x, y+vsp)) {
		y = round(y)
		while(place_free(x, y)) {
			y += sign(vsp);
		}
		while(!place_free(x, y)) {
			y -= sign(vsp);
		}
		vsp = 0;
	}
	y += vsp;
	return;
}
if(hurtCooldown > 0)hurtCooldown--;
if(global.dead)  
	return;
if(instance_exists(obj_game) && obj_game.gamePaused) 
	return;
var inv = keyboard_check_pressed(ord("I"));
//Opening/closing inventory. Handled in draw event
if(inv) {
	invOpen = !invOpen;
	//If the inventory is closed while the mouse has an item selected,
	//place that item in the lowest-index inv slot that is empty.
	if(!invOpen && clickedItem != -1) {
		var temp = copyStruct(clickedItem);
		clickedItem = -1;
		var foundSlot = false;
		for(var i = 0; i < array_length(global.invItems); i++) {
			if(global.invItems[i] == -1) {
				global.invItems[i] = temp;
				foundSlot = true;
				break;
			}
		}
		for(var i = 0; i < array_length(global.hotbarItems); i++) {
			if(foundSlot)
				break;
			if(global.hotbarItems[i] == -1) {
				global.hotbarItems[i] = temp;
				foundSlot = true;
				break;
			}
		}
		if(!foundSlot) {
			var inst = instance_create_layer(x, y, "Interactables", obj_item);
			inst.item = temp;
		}
	}
}
if(instance_exists(obj_game) && obj_game.gamePaused || obj_player.invOpen) return;
var moveLeft = keyboard_check(ord("A"));
var moveRight = keyboard_check(ord("D"));
var horizDirection = moveRight-moveLeft;
var up = keyboard_check(ord("W"));
var down = keyboard_check(ord("S"));
var vertDirection = down-up;
var jump = keyboard_check(vk_space);
global.level = 5;
global.levelUpThreshold = 480;
//Movement
{
	{//Horizontal movement
		//Checks direction  & speed of horizontal movement.
		if(isHurt) {
			hsp *= 0.8;
			if(abs(hsp) < 1) {
				isHurt = false;
				hsp = 0;
			}
		} 
		else if(lungeForward) {
			hsp *= 0.8
			if(abs(hsp) < 1) {
				lungeForward = false;
				hsp = 0;
			}
		}
		else {
			hsp = horizDirection * hspWalk;
			if(horizDirection < 0) {image_xscale = -1; direction = 180;}
			else if(horizDirection > 0) {image_xscale = 1; direction = 0;}
		}
	}
		
	{//Vertical movement
		vsp = vertDirection * hspWalk;
	}
}

{//Item usage/animations
	//Using items on left press
	leftAttackCooldown--;
	if(mouse_check_button_pressed(mb_left) && leftAttackCooldown <= 0) {
		if(is_struct(heldItem)) {
			if(heldItem.itemSpr == spr_boxingGloves) {
				leftAttackCooldown = room_speed*0.21;
				var horizontalDir = sprite_width/2;
				var verticalDir = (down-up)*sprite_height/2;
				if(verticalDir || verticalDir < 0) horizontalDir = 0;
				horizontalDir *= 2;
				sprite_index = choose(spr_playerPunchLeft, spr_playerPunchRight);
				var inst = instance_create_layer(x+horizontalDir, y+verticalDir, "Instances", obj_damageHitbox);
				inst.enemyHit = false;
				inst.instToFollow = instance_nearest(x, y, obj_player);
				inst.followOffsetX = horizontalDir;
				inst.followOffsetY = verticalDir;
				inst.damage = 1;
				inst.lifeSpan = 12;
		
				if((place_free(x-10, y) || place_free(x+10, y)) && horizontalDir != 0) {
					lungeForward = true;
					hsp = sign(sprite_width) * hspWalk;
				}
			}
		}
	}

	//Using items when holding down left
	if(mouse_check_button(mb_left) && leftAttackCooldown <= 0) {
		if(isFirearm(heldItem)) {
			leftAttackCooldown = heldItem.cooldown;
			var firedBullet = fireBullet(x, y, mouse_x, mouse_y, heldItem);
			//If mag empty, try reloading
			if(!firedBullet && mouse_check_button_pressed(mb_left)) {
				var hasReloaded = reload(heldItem);
				//If reloaded, do reload animation
				if(hasReloaded) {
					array_push(followingSequences, placeSequenceAnimation(x, y, heldItem.reloadSeq));
					leftAttackCooldown = heldItem.reloadDuration;
				}
			}
		}
	}

	//Make specific sequences follow player
	for(var i=0; i<array_length(followingSequences); i++) {
		var seq = followingSequences[i];
		if(!layer_sequence_exists("Animations", seq))
			continue;
		if(layer_sequence_is_finished(followingSequences[i]) || global.dead) {
			layer_sequence_destroy(followingSequences[i]);
			array_delete(followingSequences, i, 1);
			continue;
		}
		layer_sequence_xscale(seq, image_xscale);
		layer_sequence_x(seq, x);
		layer_sequence_y(seq, y);
	}
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
			y = round(y)
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
//Prevent player from going off-screen
x = clamp(x, 0, room_width);

//Move camera towards mouse when holding firearm
//If not firearm, center cam on player
if(instance_exists(obj_camera)) {
	if(isFirearm(heldItem)) {
		var mouseDir = point_direction(x, y, mouse_x, mouse_y)
		var mouseDist = distance_to_point(mouse_x, mouse_y);
		mouseDist = clamp(mouseDist, 0, 100);
		var xx = x+mouseDist*dcos(mouseDir);
		var yy = y-mouseDist*dsin(mouseDir);
		obj_camera.targX = xx;
		obj_camera.targY = yy;
	}
	else {
		obj_camera.targX = x;
		obj_camera.targY = y;
	}
}

//Gets rid of one health if fell into void
if(y >= room_height) {
	global.hp--;
	x = safeX;
	y = safeY;
}

//Death of player. Makes player invisible and 1s delay to respawn
if(global.hp <= 0 && !global.dead) {
	global.dead = true;
	alarm_set(0, room_speed*1);
	image_alpha = 0;
	saveGame();
}
if(!instance_exists(obj_game)) instance_create_layer(0,0, "Instances", obj_game);