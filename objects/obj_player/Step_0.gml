if(inDialogue) 
	return;
if(hurtCooldown > 0)
	hurtCooldown--;
if(global.dead)  
	return;
if(instance_exists(obj_game) && global.gamePaused) 
	return;
var inv = keyboard_check_pressed(ord("I"));
#region opening inv
//Opening/closing inventory. Handled in draw event
if(inv) {
	global.screenOpen = !global.screenOpen;
	if(global.screenOpen) {
		openPlayerInv();
	}
	else {
		closeAllScreens();
	}
}
	
#endregion opening inv

if(instance_exists(obj_game) && global.gamePaused || global.screenOpen|| state = PlayerStateLocked)
	return;

#region movement
var moveLeft = keyboard_check(ord("A"));
var moveRight = keyboard_check(ord("D"));
var horizDirection = moveRight-moveLeft;
var up = keyboard_check(ord("W"));
var down = keyboard_check(ord("S"));
var vertDirection = down-up;

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
	
if(abs(vertDirection) && abs(horizDirection)) {
	hspWalk = hspWalk/sqrt(2);
}
#endregion movement

#region items

{//Item usage/animations
	leftAttackCooldown--;
	if(isPlaceableItem(global.heldItem)) {
		if(LMOUSE_PRESSED) {
			placeItem(global.heldItem, roundToTile(mouse_x, TILEW), roundToTile(mouse_y, TILEW));
			global.hotbarItems[global.equippedItem] = -1;
		}
	}
	else if(isItem(global.heldItem)) {
		//Using items on left press
		if(LMOUSE_PRESSED && leftAttackCooldown <= 0) {
			switch(global.heldItem.itemSpr) {
				case spr_boxingGloves: boxingGloveAttack(mouse_x, mouse_y, 12); break;
				case spr_tanto: tantoStab(mouse_x, mouse_y, 12); break;
				case spr_woodHatchet : hatchetSwipe(mouse_x,mouse_y, 12); break;
			}
		}
		//Right press
		else if(RMOUSE_PRESSED && leftAttackCooldown <= 0) {
			switch(global.heldItem.itemSpr) {
				case spr_tanto: tantoSlash(mouse_x, mouse_y, 12); break;
			}
		}
		
		//Using items when holding down left
		if(mouse_check_button(mb_left) && leftAttackCooldown <= 0) {
			if(isFirearm(global.heldItem)) {
				leftAttackCooldown = global.heldItem.cooldown;
				attackState = attackStates.SHOOT;
				var firedBullet = fireBullet(x, y, mouse_x, mouse_y, global.heldItem);
				//If mag empty, try reloading
				if(!firedBullet) {
					var ammoItem = getItemFromInv(global.heldItem.ammoItemSpr);
					//If found ammo, place reload animation
					if(ammoItem != -1) {
						var inst = placeSequenceAnimation(x, y, global.heldItem.reloadSeq);
						var copy = copyStruct(global.heldItem);
						var seqStruct =
						{
							sequenceElementId : inst,
							followImageScale : true,
							followMouseDirection : false,
							assetIndex : copy.reloadSeq,
						}
						array_push(followingSequences, seqStruct);
						leftAttackCooldown = copy.reloadDuration+2;
						attackState = attackStates.RELOAD;
					}
				}
				else
					screenShake(room_speed*0.2, 10);
			}
		}
	}

}
if(leftAttackCooldown <= 0)
	attackState = attackStates.NONE;

#endregion items

#region sequences
//Make specific sequences follow player
for(var i=0; i<array_length(followingSequences); i++) {
	var seq = followingSequences[i].sequenceElementId;
	var struct = followingSequences[i];
	if(!layer_sequence_exists("Animations", seq))
		continue;
	//if sequence finished, destroy instance
	if(layer_sequence_is_finished(seq)) {
		//If holding firearm and sequence matches firearm reloading sequence, reload gun ammo
		if(isFirearm(global.heldItem)) {
			if(!layer_sequence_exists("Animations", seq))
				continue;
			if(struct.assetIndex == global.heldItem.reloadSeq) {
				reload(global.heldItem);
			}
		}
		layer_sequence_destroy(seq);
		array_delete(followingSequences, i, 1);
		continue;
	}
	var seqName = sequenceGetName(struct.assetIndex);
	//If sequence is a reload sequence, 
	if(string_pos("Reload", seqName)) {
		//If held item is fire arm and it is not matching the reloading seuqence, destroy sequence.
		if(isFirearm(global.heldItem) && global.heldItem.reloadSeq != struct.assetIndex) {
			leftAttackCooldown = 0;
			layer_sequence_destroy(seq);
			attackState = attackStates.NONE;
			continue;
		} 
		else if(!isFirearm(global.heldItem)){//If not holding firearm, destroy reload sequence
			leftAttackCooldown = 0;
			layer_sequence_destroy(seq);
			attackState = attackStates.NONE;
			continue;
		}
	}
	layer_sequence_x(seq, x);
	layer_sequence_y(seq, y);
	//Make sequence copy image scale/direction of mouse if specified to do so
	if(variable_struct_exists(struct, "followImageScale") && struct.followImageScale) {
		layer_sequence_xscale(seq, image_xscale);
		layer_sequence_yscale(seq, image_yscale);
	}
	if(variable_struct_exists(struct, "followMouseDirection") && struct.followMouseDirection)
		layer_sequence_angle(seq, point_direction(x, y, mouse_x, mouse_y));
}

#endregion sequences

if(debug_mode) {
	global.level = 5;
	global.levelUpThreshold = 480;
}

#region stamina
global.stamina = clamp(global.stamina, 0, global.maxStamina);

if(runCooldown > 0)
	runCooldown--;

//Running/stamina
{
	if(global.stamina > 10 && keyboard_check(vk_shift) && runCooldown <= 0) {
		global.stamina -= 0.6;
		hspWalk = minHspWalk*1.5;
	}
	else {
		if(runCooldown <= 0 && global.stamina <= 10)
			runCooldown = room_speed*3;
		hspWalk = minHspWalk;
	}
	global.stamina += 0.2;	
}

#endregion stamina

#region collisions
//collisions that change player spd
if(place_meeting(x, y, obj_water)) {
	hspWalk *= 0.7;
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
			var noCollide = variable_instance_exists(enem, "noCollideDmg") && enem.noCollideDmg;
			if(!noCollide && enem != noone && enem.hp > 0) {
				global.hp--;
				knockBack(enem.x, enem.y, 25);
				//isHurt = true;
				//lungeForward = false;
				//hurtCooldown = room_speed;
				//var dir = point_direction(x, y, enem.x, enem.y)-180;
				//hsp = (25*dcos(dir));
				//vsp = (-25*dsin(dir));
			}
		}
	}
	

#endregion collisions
	
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
	if(isFirearm(global.heldItem)) {
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
	global.hp = 5;
	global.dead = true;
	x = enteredX;
	y = enteredY;
	global.setPosToSpawnPos = true;
	room_goto(global.spawnRoom);
}
if(!instance_exists(obj_game)) instance_create_layer(0,0, "Instances", obj_game);

#region animations
shoulderB.x = x+3*image_xscale;
shoulderB.y = y-2;
shoulderF.x = x-3*image_xscale;
shoulderF.y = y-2;


//Handling which animation to do
if(variable_struct_exists(global.heldItem, "animationType")) {
	animType = global.heldItem.animationType;
}
else {
	if(isFirearm(global.heldItem)) {
		variable_struct_set(global.heldItem, "animationType", itemAnimations.GUN);
		animType = itemAnimations.GUN;
	}
	else
		animType = itemAnimations.NONE;
}
switch(animType) {
	case itemAnimations.NONE:
		doWalkingArmMovements(10, hspWalk*0.3, 10);
	break;
	case itemAnimations.PUNCHING: {
		//Fists up. Idle.
		if(leftAttackCooldown <= 0) {
			holdFistsUp(mouse_x, mouse_y);
		}
		else {
			doPunchingMovements(mouse_x, mouse_y);
		}
	} break;
	case itemAnimations.KNIFE_STAB: {
		if(leftAttackCooldown <= 0)
			doWalkingArmMovements(10, hspWalk*0.3, 10);
		else
			doStabMovement(mouse_x, mouse_y);
	}
}
hipB.x = x-5*sign(image_xscale);
hipB.y = y+8;
	
hipF.x = x+2*sign(image_xscale);
hipF.y = y+8;
doWalkingLegMovements(14, 5, hspWalk*0.3);

//if(isItem(global.heldItem) && global.heldItem.itemSpr == spr_boxingGloves)
//	variable_struct_set(global.heldItem, "animationType", itemAnimations.PUNCHING);
//else if(isItem(global.heldItem) && global.heldItem.itemSpr == spr_tanto)
//	variable_struct_set(global.heldItem, "animationType", itemAnimations.KNIFE_STAB);

#endregion animations