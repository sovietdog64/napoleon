solid = false;
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

if(mouse_x - x >= 0)
	image_xscale = abs(image_xscale);
else
	image_xscale = -abs(image_xscale);

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

//Horizontal movement
if(!isHurt && !lungeForward) {
	hsp = horizDirection * walkSpd;
	direction = point_direction(x, y, mouse_x, mouse_y)
}

		
//Vertical movement
if(!isHurt && !lungeForward)
	vsp = vertDirection * walkSpd;

	
if(hsp != 0 && vsp != 0) {
	hsp /= sqrt(2);
	vsp /= sqrt(2);
}
#endregion movement

#region items

var canLeftPress = variable_struct_exists(global.heldItem, "leftPress");
var canRightPress = variable_struct_exists(global.heldItem, "rightPress");

var canLeftDown = variable_struct_exists(global.heldItem, "leftDown");
var canRightDown = variable_struct_exists(global.heldItem, "rightDown");


var spr = isItem(global.heldItem) ? global.heldItem.itemSpr : 0;

{//Updating list of cooldowns for missing items
	//Add to cooldowns if this item is not in the list.
	if(canLeftPress && !arrayInBounds(leftAttackCooldowns, spr)) {
		array_insert(leftAttackCooldowns, spr, 0)
	}
		
	//Add to cooldowns if this item is not in the list.
	if(canRightPress && !arrayInBounds(rightAttackCooldowns, spr)) {
		array_insert(rightAttackCooldowns, spr, 0);
	}
}

{//Item usage/animations
	if(isItem(global.heldItem)) {
		
		decrementCooldowns(leftAttackCooldowns)
		decrementCooldowns(rightAttackCooldowns)
		
		//Left press
		{
			//Will skip the leftclick if there isn't a leftclick action
			if(LMOUSE_PRESSED && canLeftPress && leftAttackCooldowns[spr] <= 0) { 
				//If cooldown is 0 for this item, then do its left click action
				var cooldown = global.heldItem.leftPress(mouse_x, mouse_y);
				if(is_numeric(cooldown))
					leftAttackCooldowns[spr] = cooldown;
			}
		}
		
		{//Left down
			if(LMOUSE_DOWN && canLeftDown && leftAttackCooldowns[spr] <= 0) {
				//If cooldown is 0 for this item, then do its left click action
				var cooldown = global.heldItem.leftDown(mouse_x, mouse_y);
				if(is_numeric(cooldown))
					leftAttackCooldowns[spr] = cooldown;
			}
		}
		
			
		//Right press
		{
			 //Will skip the rightclick if there isn't a rightclick action
			if(RMOUSE_PRESSED && canRightPress && rightAttackCooldowns[spr] <= 0) {	
				//If cooldown is 0 for this item, then do its right click action
				var cooldown = global.heldItem.rightPress(mouse_x, mouse_y);
				if(is_numeric(cooldown))
					rightAttackCooldowns[spr] = cooldown;
			}
		}
			
		{//Right down
			if(LMOUSE_DOWN && canRightDown && rightAttackCooldowns[spr] <= 0) {
				//If cooldown is 0 for this item, then do its right click action
				var cooldown = global.heldItem.rightDown(mouse_x, mouse_y);
				if(is_numeric(cooldown))
					rightAttackCooldowns[spr] = cooldown;
			}
		}
		
	}

}
	
	
if(isItem(global.heldItem))
	if(canLeftPress && leftAttackCooldowns[global.heldItem.itemSpr] <= 0)
		attackState = attackStates.NONE
else
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
		walkSpd = minWalkSpd*1.5;
	}
	else {
		if(runCooldown <= 0 && global.stamina <= 10)
			runCooldown = room_speed*3;
		walkSpd = minWalkSpd;
	}
	global.stamina += 0.2;	
}

#endregion stamina

#region collisions
//collisions that change player spd
if(place_meeting(x, y, obj_water)) {
	walkSpd *= 0.7;
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

if(global.hp <= 0 && !global.dead) {
	global.dead = true;
	image_alpha = 0;
	alarm_set(0, room_speed*3);
}

#region animations

//Setting limb positions
{//arms
	shoulderB.x = x+5*image_xscale;
	shoulderB.y = y-2;
	hBOrigin.x = shoulderB.x;
	hBOrigin.y = y+10;

	shoulderF.x = x-3*image_xscale;
	shoulderF.y = y-2;
	hFOrigin.x = shoulderF.x;
	hFOrigin.y = y+10;
}

{//legs
	hipB.x = x-5*sign(image_xscale);
	hipB.y = y+8;
	fBOrigin.x = hipB.x;
	fBOrigin.y = hipB.y+legLen-footRadius;
	
	hipF.x = x+2*sign(image_xscale);
	hipF.y = y+8;
	fFOrigin.x = hipF.x;
	fFOrigin.y = hipF.y+legLen-footRadius;
}


var dirFacing = sign(x - xprevious);
if(dirFacing == 0)
	dirFacing = sign(image_xscale);

var spr = 0;

if(isItem(global.heldItem)) {
	animType = global.heldItem.animationType;
	spr = global.heldItem.itemSpr;
}
else
	animType = itemAnimations.NONE;


switch(animType) {
	case itemAnimations.NONE: 
		walkMovements(footRadius, walkAnimSpd, dirFacing);
	break;
	case itemAnimations.KNIFE_STAB: {
		legWalk(footRadius, walkAnimSpd, dirFacing)
		if(leftAttackCooldowns[spr] > 0) {
			knifeStab(legLen*2, mouse_x, mouse_y, 13);
			armBehindWalk(footRadius, walkAnimSpd, dirFacing);
		} else
			armWalk(footRadius, walkAnimSpd, dirFacing);
	} break;
	
	case itemAnimations.SWORD: {
		legWalk(footRadius, walkAnimSpd, dirFacing)
		if(leftAttackCooldowns[spr] > 0) {
			var factor = 20/global.heldItem.cooldown;
			factor *= 1.2;
			swordSwipe(mouse_x, mouse_y,(walkAnimSpd/2)*factor*1.1, 90*factor*1.1, image_xscale);
			armBehindWalk(footRadius, walkAnimSpd, dirFacing);
		} else {
			armWalk(footRadius, walkAnimSpd, dirFacing);
		}
	}break;
}


#endregion animations