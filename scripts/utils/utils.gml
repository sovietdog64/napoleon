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
		global.hotbarItems[i] = item;
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

function Item(itemSprite, itemAmount, dmg) constructor {
	itemSpr = itemSprite;
	amount = itemAmount;
	damage = dmg;
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
	function fireBullet(shooterX, shooterY, targX, targY, firearm) {
							if(firearm.currentAmmoAmount <= 0) {
								return 0;
							}
							var bullet = instance_create_layer(shooterX, shooterY, "Instances", obj_bullet);
							bullet.sprite_index = firearm.projectileSpr;
							bullet.direction = point_direction(shooterX, shooterY, targX, targY);
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
	
	function FirearmSemi(itemSprite, ammoItemSprite, projectileSprite, ammoNameStr, dmg, bulletSpeed, shootSeqIndex, reloadSeqIndex, fireCooldown, ammoStorageSize, reloadCooldown) constructor {
		//Sprite variables must end with "Spr" with correct capitalization in order to save correctly (i couldn't find any other way of doing this because gamemaker is a lil dum sometimes)
		itemSpr = itemSprite;
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
		shootSeq = shootSeqIndex;
		cooldown = fireCooldown;
		ammoCapacity = ammoStorageSize;
		currentAmmoAmount = ammoCapacity;
		reloadDuration = reloadCooldown;
	}
	
	function FirearmAuto(itemSprite, ammoItemSprite, projectileSprite, ammoNameStr, dmg, bulletSpeed, shootSeqIndex, reloadSeqIndex, fireCooldown, ammoStorageSize, reloadCooldown) constructor {
		var firearm = new FirearmSemi(itemSprite, ammoItemSprite, projectileSprite, ammoNameStr, dmg, bulletSpeed, shootSeqIndex, reloadSeqIndex, fireCooldown, ammoStorageSize, reloadCooldown); 
		firearm.fireMode = "auto";
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