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
	
	function Firearm(itemSprite, ammoItemSprite, projectileSprite, ammoNameStr, dmg, bulletSpeed, reloadSeqIndex, fireCooldown, ammoStorageSize, reloadCooldown) constructor {
		//Sprite variables must end with "Spr" with correct capitalization in order to save correctly (i couldn't find any other way of doing this because gamemaker is a lil dum sometimes)
		itemSpr = itemSprite;
		firearm = true;
		amount = 1;
		ammoItemSpr = ammoItemSprite;
		projectileSpr = projectileSprite;
		ammoName = ammoNameStr;
		damage = dmg;
		bulletSpd = bulletSpeed;
		//Sequence variables must end with "Seq" with correct capitalization in order to save correctly
		reloadSeq = reloadSeqIndex;
		cooldown = fireCooldown;
		ammoCapacity = ammoStorageSize;
		currentAmmoAmount = ammoCapacity;
		reloadDuration = reloadCooldown;
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

//Returns if string contains substring without case sensitivity
function stringContainsNoCase(str, substr) {
	return string_pos(string_lower(substr),string_lower(str));
}

//Returns if string contains substring WITH case sensitivity
function stringContains(str, substr) {
	return string_pos(substr, str);
}