//@function giveItemToPlayer
//@param item sprite of item to give
//Returns 1 if successfully gave item. Returns 0 if inventory too full
function giveItemToPlayer(item) {
	//Trying to give to hotbar
	for(var i=0; i<array_length(global.hotbarItems); i++) {
		var hotbarItem = global.hotbarItems[i];
		if(isItem(hotbarItem)) {
			if(hotbarItem.itemSpr == item.itemSpr) {
				hotbarItem.amount += item.amount;
				return 1;
			}
			else 
				continue;
		}
		global.hotbarItems[i] = copyStruct(item);
		return 1;
	}
	//Trying to give to inventory
	for(var i=0; i<array_length(global.invItems); i++) {
		var invItem = global.invItems[i];
		if(isItem(invItem)) {
			if(invItem.itemSpr == item.itemSpr) {
				invItem.amount += item.amount;
				return 1;
			}
			else
				continue;
		}
		global.invItems[i] = item;
		return 1;
	}
	return 0;
}

function copyStruct(struct){
	if(!is_struct(struct))
		return -1;
    var key, value;
    var newCopy = {};
    var keys = variable_struct_get_names(struct);
    for (var i = array_length(keys)-1; i >= 0; --i) {
            key = keys[i];
            value = struct[$ key];
            variable_struct_get(struct, key);
            variable_struct_set(newCopy, key, value)
    }
    return newCopy;
}

function Item(itemSprite, itemAmount, dmg, animationTypeEnum = itemAnimations.NONE) constructor {
	itemSpr = itemSprite;
	amount = itemAmount;
	damage = dmg;
	animationType = animationTypeEnum;
}

function sequenceGetName(sequenceId) {
	if(layer_exists("Animations") &&  layer_sequence_exists("Animations", sequenceId)) {
		return layer_sequence_get_sequence(sequenceId).name;
	}
	try {
		return sequence_get(sequenceId).name;
	}
	catch(err) {
		return -1;
	}
}

{//Fire arm
	function fireBullet(shooterX, shooterY, targX, targY, firearm, enemyHit = false, inaccuracy = 0) {
		if(firearm.currentAmmoAmount <= 0) {
			return 0;
		}
		var bullet = instance_create_layer(shooterX, shooterY, "Instances", obj_bullet);
		bullet.enemyDamage = enemyHit;
		bullet.sprite_index = firearm.projectileSpr;
		bullet.direction = point_direction(shooterX, shooterY, targX, targY)+random(inaccuracy);
		bullet.spd = firearm.bulletSpd;
		bullet.damage = firearm.damage;
		firearm.currentAmmoAmount--;
		return 1;
	}
	//Returns 1 if reloaded, 0 if no more ammo left completely
	function reload(firearm) {
		//Finding ammo in hotbar
		for(var i=0; i<array_length(global.hotbarItems); i++) {
			var item = global.hotbarItems[i];
			if(!isItem(item))
				continue;
			if(item.itemSpr == firearm.ammoItemSpr) {
				item.amount -= firearm.ammoCapacity;
				firearm.currentAmmoAmount = firearm.ammoCapacity;
				if(item.amount < 0) {
					firearm.currentAmmoAmount += item.amount;
					item.amount = 0;
				}
				return 1;
			}
		}
		//Finding ammo in inventory
		for(var i=0; i<array_length(global.invItems); i++) {
			var item = global.invItems[i];
			if(!isItem(item))
				continue;
			if(item.itemSpr == firearm.ammoItemSpr) {
				item.amount -= firearm.ammoCapacity;
				firearm.currentAmmoAmount = firearm.ammoCapacity;
				if(item.amount < 0) {
					firearm.currentAmmoAmount += item.amount;
					item.amount = 0;
				}
				return 1;
			}
		}
		//Return 0 when finding ammo has failed
		return 0;
	}
	
	function FirearmSemi(gunTypeEnum, itemSprite, ammoItemSprite, projectileSprite, ammoNameStr, dmg, bulletSpeed, shootDur, reloadSeqIndex,  magSize, magSprite = -1, noMagSprite = -1, animationTypeEnum = itemAnimations.GUN) constructor {
		//Sprite variables must end with "Spr" with correct capitalization in order to save correctly (i couldn't find any other way of doing this because gamemaker is a lil dum sometimes)
		itemSpr = itemSprite;
		gunType = gunTypeEnum;
		firearm = true;
		fireMode = "semi"
		amount = 1;
		ammoItemSpr = ammoItemSprite;
		projectileSpr = projectileSprite;
		ammoName = ammoNameStr;
		damage = dmg;
		bulletSpd = bulletSpeed;
		//Sequence variables must end with "Seq" with correct capitalization in order to save correctly
		reloadSeq = reloadSeqIndex;
		ammoCapacity = magSize;
		currentAmmoAmount = ammoCapacity;
		cooldown = shootDur;
		reloadDuration = getSequenceLength(reloadSeqIndex)+1;
		magSpr = magSprite;
		noMagSpr = noMagSprite;
		animationType = animationTypeEnum;
	}
	
	function FirearmAuto(gunTypeEnum, itemSprite, ammoItemSprite, projectileSprite, ammoNameStr, dmg, bulletSpeed, shootDur, reloadSeqIndex, magSize, magSprite = -1, noMagSprite = -1, animationTypeEnum = itemAnimations.GUN) constructor {
		//Sprite variables must end with "Spr" with correct capitalization in order to save correctly (i couldn't find any other way of doing this because gamemaker is a lil dum sometimes)
		itemSpr = itemSprite;
		gunType = gunTypeEnum;
		firearm = true;
		fireMode = "auto";
		amount = 1;
		ammoItemSpr = ammoItemSprite;
		projectileSpr = projectileSprite;
		ammoName = ammoNameStr;
		damage = dmg;	
		bulletSpd = bulletSpeed;
		//Sequence variables must end with "Seq" with correct capitalization in order to save correctly
		reloadSeq = reloadSeqIndex;
		ammoCapacity = magSize;
		currentAmmoAmount = ammoCapacity;
		cooldown = shootDur;
		reloadDuration = getSequenceLength(reloadSeqIndex)+1;
		magSpr = magSprite;
		noMagSpr = noMagSprite;
		animationType = animationTypeEnum;
	}
	
	
	
	function isFirearm(item) {
		return isItem(item) && variable_struct_exists(item, "firearm") && item.firearm;
	}
		
	//Returns 1 if no more ammo for inputted firearm
	function noAmmo(firearm) {
		if(firearm.currentAmmoAmount > 0)
			return 0;
		for(var i=0; i<array_length(global.invItems); i++) {
			var item = global.invItems[i];
			if(!isItem(item))
				continue;
			if(item.itemSpr == firearm.ammoItemSpr) {
				return 0;
			}
		}
		for(var i=0; i<array_length(global.hotbarItems); i++) {
			var item = global.hotbarItems[i];
			if(!isItem(item))
				continue;
			if(item.itemSpr == firearm.ammoItemSpr) {
				return 0;
			}
		}
		return 1;
	}
}

function isItem(item) {
	return is_struct(item) && variable_struct_exists(item, "itemSpr");
}
	
function purchaseItem(item, price, levelReq) {
	//TODO:check if enough money
	if(global.level >= levelReq) {
		giveItemToPlayer(id.item)
		//TODO:Take away money
	}
	else if(global.level <= levelReq){
		newTextBox("$FF0000 Need level " + string(levelReq), , 2);
	}
}
	
function getItemFromInv(itemSprite, amountNeeded = 1) {
	for(var i=0; i<array_length(global.hotbarItems); i++) {
		var invItem = global.hotbarItems[i];
		if(!isItem(invItem))
			continue;
		if(invItem.itemSpr == itemSprite && invItem.amount >= amountNeeded) 
			return invItem;
	}
	for(var i=0; i<array_length(global.invItems); i++) {
		var invItem = global.invItems[i];
		if(!isItem(invItem))
			continue;
		if(invItem.itemSpr == itemSprite && invItem.amount >= amountNeeded) 
			return invItem;
	}
	return -1;
}

//Returns if string contains substring without case sensitivity
function stringContainsNoCase(str, substr) {
	return string_pos(string_lower(substr),string_lower(str));
}

//Returns if string contains substring WITH case sensitivity
function stringContains(substr, str) {
	return string_pos(substr, str);
}
	
{//Quest funcs
	//Creates basic quest struct. Add variables individually to the struct if you want extra features.
	function Quest(name, desc, xpGain, maxLevel, qProgress, qMaxProgress, qGiver, itemRewards = -1, goldReward = 0) constructor {
		questName = name;
		questDesc = desc;
		xpReward = xpGain;
		maxLvl = maxLevel;
		questItems = itemRewards;
		gold = goldReward;
	
		progress = qProgress;
		maxProgress = qMaxProgress;
		questGiver = qGiver;
		progressPercentage = progress/maxProgress;
	}

	//Returns 1 when assinged quest. 0 if quest is currently active, -1 if quest already completed
	function assignQuest(questStruct) {
		for(var i=0; i<array_length(global.activeQuests); i++) {
			var activeQuest = global.activeQuests[i];
			if(activeQuest.questName == questStruct.questName) {
				return 0;
			}
		}
		for(var i=0; i<array_length(global.completedQuests); i++) {
			var completedQuest = global.completedQuests[i];
			if(completedQuest.questName == questStruct.questName) {
				return -1;
			}
		}
		array_push(global.activeQuests, questStruct);
		return 1;
	}
	

	function completeQuest(nameOfQuest) {
		var quest = getActiveQuest(nameOfQuest);
		if(quest != 0) {
			//Giving XP.
			if(global.level <= quest.maxLvl) {
				global.xp += quest.xpReward;
			}
			else
				global.xp += round(quest.xpReward/5);
			
			//Give reward items
			if(is_array(quest.questItems)) {
				for(var j=0; j<array_length(quest.questItems); j++) {
					if(isItem(quest.questItems[j]))
						giveItemToPlayer(quest.questItems[j]);
				}
			}
			
			//TODO: Add gold reward
			removeQuest(nameOfQuest);
			return 1;
		}
		return 0;
	}
	
	//Remove active quest. return 1 if successful, 0 otherwise
	function removeQuest(nameOfQuest) {
		for(var i=0; i<array_length(global.activeQuests); i++) {
			if(global.activeQuests[i].questName == nameOfQuest) {
				array_delete(global.activeQuests, i, 1);
				return 1;
			}
		}
		return 0;
	}
	
	//Returns active quest searched by name. return 0 if quest not exist
	function getActiveQuest(nameOfQuest) {
		for(var i=0; i<array_length(global.activeQuests); i++) {
			var quest = global.activeQuests[i];
			if(quest.questName == nameOfQuest) {
				return quest;
			}
		}
		return 0;
	}
	
	//Returns 1 if successfully added progress to quest, 0 otherwise.
	function addQuestProgress(nameOfQuest, amount) {
		var quest = getActiveQuest(nameOfQuest);
		if(quest != 0) {
			var prevProg = copyStruct(quest).progressPercentage;
			quest.progress += amount;
			quest.progressPercentage = quest.progress/quest.maxProgress;
			quest.progressPercentage = clamp(quest.progressPercentage, 0 ,1);
			if(quest.progressPercentage == 1 && prevProg != 1)
				newTextBox("You completed " + nameOfQuest + " quest!", undefined, 1);
			return 1;
		}
		return 0;
	}
}

function Point(px, py) constructor {
	x = px;
	y = py;
}

function Line(_x1, _y1, _x2, _y2) constructor {
	x1 = _x1; 
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
	length = distanceBetweenPoints(x1, y1, x2, y2);
	dir = point_direction(x1, y1, x2, y2);
	midpoint = lineMidpoint(x1, y1, x2, y2);
}

function lineMidpoint(x1, y1, x2, y2) {
	var xx = (x1+x2)/2;
	var yy = (y1+y2)/2;
	return new Point(xx, yy);
}

function raycast4Directional(distance, incrementInPixels, preciseCheck) {
	for(var i=0; i < 361; i+=90) {
		var len = 1;
		while(len < distance) {
			var xx = x+lengthdir_x(len, i);
			var yy = y+lengthdir_y(len, i);
			if(collision_point(xx, yy, obj_solid, preciseCheck, 1)) {
				return 1;
			}
			len += incrementInPixels;
		}
	}
	return undefined;
}
	
function getVarAssetName(varName, varValue) {
	if (stringContains("Spr", varName))
		return sprite_get_name(varValue);
		
	if (stringContains("Seq", varName))
		return sequenceGetName(varValue); 
		
	if (stringContains("Obj", varName))
		return object_get_name(varValue);
		
	if (stringContains("Rm", varName) || stringContains("Room", varName))
		return room_get_name(varValue);
	return 0;
}

function instSetVars(inst, varStruct) {
	var keys = variable_struct_get_names(varStruct);
	for(var i=0; i<array_length(keys); i++) {
		var key = keys[i], value = variable_struct_get(varStruct, key);
		if(is_string(value))
			if(asset_get_type(value) != asset_unknown)
				value = asset_get_index(value);
		variable_instance_set(inst, key, value);
	}
}

function getSequenceLength(sequenceAssetID) {
	if(!sequence_exists(sequenceAssetID))
		return -1;
	return sequence_get(sequenceAssetID).length;
}
	
function screenShake(duration, screenShakeLevel) {
	if(instance_exists(obj_camera)) {
		with(obj_camera) {
			screenShakeDuration = duration;
			screenShakeLvl = screenShakeLevel;
			alarm_set(0, 1);
		}
	}
}
	
function dropItem(item, xx, yy) {
	if(!isItem(item))
		return 0;
	var inst = instance_create_layer(xx, yy, "Interactables", obj_item);
	inst.item = item;
}
	
function distanceToRectangle(px, py, x1, y1, x2, y2) {
	var dx = max(x1 - px, 0, px - x2);
	var dy = max(y1 - py, 0, py - y2);
	return sqrt(dx*dx + dy*dy);
}
	
function numRound(num) {
	var val = frac(num)
	if(val < 0.5) 
		return floor(num);
	else
		return ceil(num);
}
	
function randPointInCircle(radius, snapToTile = false) {
	var theta = 2*pi*random(1);
	var u = random(1)+random(1);
	var r;
	if(u > 1) 
		r = 2-u
	else
		r = u
	var xx = radius*r*cos(theta);
	var yy = radius*r*sin(theta);
	if(snapToTile) {
		xx = roundToTile(xx, TILEW/8);
		yy = roundToTile(yy, TILEW/8);
	}
	return new Point(xx, yy);
}

function randPointInEllipse(ellipseWidth, ellipseHeight, snapToTile = false) {
	var theta = 2*pi*random(1);
	var u = random(1)+random(1);
	var r;
	
	if(u > 1) 
		r = 2-u
	else
		r = u

	var xx = ellipseWidth*r*cos(theta)/2;
	var yy = ellipseHeight*r*sin(theta)/2;
	if(snapToTile) {
		xx = roundToTile(xx, TILEW/8);
		yy = roundToTile(yy, TILEW/8);
	}
	return new Point(xx, yy);
}

function roundToTile(num, tileSize) {
	return floor(((num + tileSize - 1)/tileSize))*tileSize;
}
	
function pointDistanceToLine(px, py, x1, y1, x2, y2) {
	var numerator = abs((x2-x1)*(y1-py) - (x1-px)*(y2-y1));
	var denominator = distanceBetweenPoints(x1, y1, x2, y2);
	return numerator/denominator;
}

function getSpriteCenter(sprite, xx, yy) {
	var w = sprite_get_width(sprite);
	var h = sprite_get_height(sprite);
	var centerX = xx - sprite_get_xoffset(sprite) + w/ 2;
	var centerY = yy - sprite_get_yoffset(sprite) + h/ 2;
	return new Point(centerX, centerY);
}