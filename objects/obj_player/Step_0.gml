var heldItem = global.hotbarItems[global.equippedItem];
if(inDialogue) 
	return;
if(hurtCooldown > 0)hurtCooldown--;
if(global.dead)  
	return;
if(instance_exists(obj_game) && global.gamePaused) 
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
if(instance_exists(obj_game) && global.gamePaused || obj_player.invOpen || state = PlayerStateLocked)
	return;
var moveLeft = keyboard_check(ord("A"));
var moveRight = keyboard_check(ord("D"));
var horizDirection = moveRight-moveLeft;
var up = keyboard_check(ord("W"));
var down = keyboard_check(ord("S"));
var vertDirection = down-up;
global.level = 5;
global.levelUpThreshold = 480;
//Movement
{
	{//Horizontal movement
		//Checks direction  & speed of horizontal movement.
		if(isHurt) {
			hsp *= 0.8;
			vsp *= 0.8;
			if(abs(hsp) < 1 && abs(vsp) < 1) {
				isHurt = false;
				hsp = 0;
				vsp = 0;
			}
		} 
		else if(lungeForward) {
			hsp *= 0.8;
			vsp *= 0.8;
			if(abs(hsp) < 1 && abs(vsp) < 1) {
				lungeForward = false;
				hsp = 0;
				vsp = 0;
			}
		}
		else {
			hsp = horizDirection * hspWalk;
			if(horizDirection < 0) {image_xscale = -1; direction = 180;}
			else if(horizDirection > 0) {image_xscale = 1; direction = 0;}
		}
	}
		
	{//Vertical movement
		if(!isHurt && !lungeForward)
			vsp = vertDirection * hspWalk;
	}
}

{//Item usage/animations
	leftAttackCooldown--;
	if(isItem(heldItem)) {
		//Using items on left press
		if(mouse_check_button_pressed(mb_left) && leftAttackCooldown <= 0) {
			switch(heldItem.itemSpr) {
				case spr_boxingGloves: boxingGloveAttack(mouse_x, mouse_y, 12); break;
				case spr_tanto: tantoAttack(mouse_x, mouse_y, 12); break;
			}
		}
		//Right press
		else if(mouse_check_button_pressed(mb_right) && leftAttackCooldown <= 0) {
			switch(heldItem.itemSpr) {
				case spr_tanto: tantoSlash(mouse_x, mouse_y, 12); break;
			}
		}
		
		//Using items when holding down left
		if(mouse_check_button(mb_left) && leftAttackCooldown <= 0) {
			if(isFirearm(heldItem)) {
				leftAttackCooldown = heldItem.cooldown;
				var firedBullet = fireBullet(x, y, mouse_x, mouse_y, heldItem);
				//If mag empty, try reloading
				if(!firedBullet) {
					var ammoItem = getItemFromInv(heldItem.ammoItemSpr);
					//If found ammo, place reload animation
					if(ammoItem != 0) {
						var inst = placeSequenceAnimation(x, y, heldItem.reloadSeq);
						var copy = copyStruct(heldItem);
						var seqStruct =
						{
							sequenceElementId : inst,
							followPlayerScale : true,
							assetIndex : copy.reloadSeq,
						}
						array_push(followingSequences, seqStruct);
						leftAttackCooldown = copy.reloadDuration;
					}
				}
				else if(firedBullet && instance_exists(obj_camera))
					obj_camera.screenShake(room_speed*0.2, 10);
			}
		}
	}
}

//Make specific sequences follow player
for(var i=0; i<array_length(followingSequences); i++) {
	var seq = followingSequences[i].sequenceElementId;
	if(!layer_sequence_exists("Animations", seq))
		continue;
	//if sequence finished, destroy instance
	if(layer_sequence_is_finished(seq)) {
		//If holding firearm and sequence matches firearm reloading sequence, reload gun ammo
		if(isFirearm(heldItem)) {
			if(!layer_sequence_exists("Animations", seq))
				continue;
			if(followingSequences[i].assetIndex == heldItem.reloadSeq) {
				reload(heldItem);
			}
		}
		layer_sequence_destroy(seq);
		array_delete(followingSequences, i, 1);
		continue;
	}
	var seqName = sequenceGetName(followingSequences[i].assetIndex);
	//If sequence is a reload sequence, 
	if(string_pos("Reload", seqName)) {
		//If held item is fire arm and it is not matching the reloading seuqence, destroy sequence.
		if(isFirearm(heldItem) && heldItem.reloadSeq != followingSequences[i].assetIndex) {
			leftAttackCooldown = 0;
			layer_sequence_destroy(seq);
			continue;
		} 
		else if(!isFirearm(heldItem)){//If not holding firearm, destroy reload sequence
			leftAttackCooldown = 0;
			layer_sequence_destroy(seq);
			continue;
		}
	}
	layer_sequence_x(seq, x);
	layer_sequence_y(seq, y);
	if(variable_struct_exists(followingSequences[i], "followPlayerScale") && followingSequences[i].followPlayerScale) {
		layer_sequence_xscale(seq, image_xscale);
		layer_sequence_yscale(seq, image_yscale);
	}
}


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
	
{//Enemy collision
		if(hurtCooldown > 0) 
			hurtCooldown--;
		if(hurtCooldown <= 0 && !isHurt) {
			var enem = instance_place(x, y, obj_enemy);
			if(enem != noone) {
				global.hp--;
				isHurt = true;
				lungeForward = false;
				hurtCooldown = room_speed;
				var dir = point_direction(x, y, enem.x, enem.y)-180;
				hsp = (25*dcos(dir));
				vsp = (-25*dsin(dir));
			}
		}
	}
	
{//Completeting quests
	var nearestNPC = instance_nearest(x, y, obj_npc);
	if(nearestNPC != noone && distance_to_point(nearestNPC.x, nearestNPC.y) <= 100) {
		for(var i=0; i<array_length(global.activeQuests); i++) {
			var quest = global.activeQuests[i];
			//If quest not complete, skip
			if(quest.progressPercentage < 1)
				continue;
			//If quest complete, check if quest giver is nearby
			if(nearestNPC.npcName == quest.questGiver) {
				//If quest giver nearby, make NPC finish quest with its custom actions.
				nearestNPC.finishQuest = true;
				completeQuest(quest.questName);
				break;
			}
		}
	}
}	

//Prevent from going off-screen
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);

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

//Death of player. Makes player invisible and 1s delay to respawn
if(global.hp <= 0 && !global.dead) {
	global.dead = true;
	alarm_set(0, room_speed*1);
	image_alpha = 0;
	saveGame();
}
if(!instance_exists(obj_game)) instance_create_layer(0,0, "Instances", obj_game);