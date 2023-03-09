#region item classes

function Item(itemSprite, itemAmount, dmg, itemName, itemDescription, animationTypeEnum = itemAnimations.NONE) constructor {
	itemSpr = itemSprite;
	amount = itemAmount;
	damage = dmg;
	name = itemName;
	desc = itemDescription;
	animationType = animationTypeEnum;
}

function Placeable(sprite, rightClickFunction = undefined, leftClickFunction = undefined) {
	placedSprite = sprite;
	rightClickAction = rightClickFunction;
	leftClickAction = leftClickFunction;
}
	
function Pickaxe(itemSprite, itemAmount, dmg, itemName, itemDescription, animationTypeEnum = itemAnimations.KNIFE_STAB) : Item(itemSprite, itemAmount, dmg, itemName, itemDescription, animationTypeEnum) constructor {}

function Sword(itemSprite, itemAmount, _cooldown, _range, dmg, itemName, itemDescription) : 
	Item(itemSprite, itemAmount, dmg, itemName, itemDescription, itemAnimations.SWORD) constructor {
	cooldown = _cooldown;
	range = _range;
	static leftPress = function(targX, targY) {
		with(other) {
			handProgress = 1;
			attackState = attackStates.MELEE;
			animType = itemAnimations.SWORD;
			var dir = point_direction(x, y, targX, targY);
			//Calculate the direction of the punch hitbox
			var xx = x + lengthdir_x(other.range, dir);
			var yy = y + lengthdir_y(other.range, dir);
			//Create dmg hitbox (hitboxes are more resource efficient compared to individial enemy collision checks)
			damageHitbox(
				xx,yy,
				24,24,
				targX,targY,
				other.damage,
				other.cooldown,3,
				object_is_ancestor(object_index, obj_enemy),
				true, false,
				xx-x,yy-y
			).sprite_index = spr_swipe;
		}
		return cooldown;
	}
}

function Axe(itemSprite, itemAmount, _cooldown, _range, dmg, itemName, itemDescription) : 
	Item(itemSprite, itemAmount, dmg, itemName, itemDescription, itemAnimations.KNIFE_STAB) constructor {
	cooldown = _cooldown;
	range = _range;
	static leftPress = function(targX, targY) {
		with(other) {
			handProgress = 1;
			attackState = attackStates.MELEE;
			animType = itemAnimations.SWORD;
			var dir = point_direction(x, y, targX, targY);
			//Calculate the direction of the punch hitbox
			var xx = x + lengthdir_x(other.range, dir);
			var yy = y + lengthdir_y(other.range, dir);
			//Create dmg hitbox (hitboxes are more resource efficient compared to individial enemy collision checks)
			damageHitbox(
				xx,yy,
				24,24,
				targX,targY,
				other.damage,
				other.cooldown,3,
				object_is_ancestor(object_index, obj_enemy),
				true, false,
				xx-x,yy-y
			).sprite_index = spr_swipe;
		}
		return cooldown;
	}
}

function Food(itemSprite, itemAmount, healAmount, dmg, itemName, itemDescription) : 
	Item(itemSprite, itemAmount, dmg, itemName, itemDescription) constructor {
	heal = healAmount;
	static leftPress = function() {
		with(other) {
			if(object_index == obj_player) {
				global.hp += other.heal;
				if(global.hp > global.maxHp)
					global.hp = global.maxHp;
			}
			else {
				hp += other.heal;
				if(hp > maxHp)
					hp = maxHp;
			}
		}
			
		amount--;
	}
}

#endregion item classes

#region item utils

//Returns the amount needed to remove after removing
//Ex. item has amount of 3. amount to remove was 10. The item's amount will be subtracted to 0, and the func will return 7, because 3 out of 10 items were removed.
function removeFromItem(item, amountToRemove) {
	if(!isItem(item))
		return -1;
	var diff = item.amount - amountToRemove;
	if(diff < 0) {
		var temp = item.amount;
		item.amount = 0;
		amountToRemove -= temp;
	}
	else if(diff > 0) {
		item.amount -= amountToRemove;
		amountToRemove = 0;
	}
	else if(diff == 0) {
		item.amount -= amountToRemove;
		amountToRemove = 0;
	}
	
	return amountToRemove;
}

function placeItem(placeableItem, placeX, placeY) {
	if(!is_struct(placeableItem))
		return 0;
	if(!variable_struct_exists(placeableItem, "placedSprite"))
		return 0;
	var newItem = duplicateItem(placeableItem);
	newItem.amount = 1;
	placeableItem.amount--;
	instance_create_layer(
		placeX, placeY,
		"Instances",
		obj_placeable,
		{
			item : newItem,
		}
	);
	
	return 1;
}
	
function itemsAreSame(item, item2) {
	if(!isItem(item) || !isItem(item2))
		return false;
	return 
		item.itemSpr == item2.itemSpr &&
		item.name == item2.name &&
		item.desc == item2.desc &&
		instanceof(item) == instanceof(item2) &&
		item.animationType == item2.animationType;
}

function itemsAreSimilar(item, item2, includeAmount = false) {
	if(!isItem(item) || !isItem(item2))
		return false;
	var boolean = instanceof(item) == instanceof(item2);
	if(includeAmount)
		boolean = instanceof(item) == instanceof(item2) && item.amount == item2.amount;
	return boolean;
}

function decrementCooldowns(cooldownArr) {
	for(var i=0; i<array_length(cooldownArr); i++) {
		if(is_numeric(cooldownArr[i]))
			cooldownArr[i] -= 1;
	}
}

#endregion item utils
	
function CraftingRecipie(_item, _itemsRequired, _toolsRequired = undefined) constructor {
	item = _item;
	itemsRequired = _itemsRequired;
	toolsRequired = _toolsRequired;
	itemsAndTools = itemsRequired;
	
	if(is_array(toolsRequired))
		itemsAndTools = array_concat(itemsRequired, toolsRequired)
	
	//Checks if can craft an item
	//If cannot, it will return an array of the missing items
	static canCraft = function(craftInv) {
		return InvSearchContainsOnly(craftInv, itemsAndTools);
	}
	
	static craftItem = function(craftInv) {
		var craftPossible = canCraft(craftInv);
		if(craftPossible == true) {
			//Remove all items that are not needed
			for(var i=0; i<array_length(itemsRequired); i++) {
				var reqItem = itemsRequired[i];
				var neededItems = [];
				if(!is_array(craftInv))
					neededItems = InvGetPlayer(reqItem.itemSpr, reqItem.amount);
				else
					neededItems = InvGet(craftInv, reqItem.itemSpr, reqItem.amount);
				if(!is_array(neededItems))
					neededItems = array_create(1, neededItems)
				var amountToRemove = reqItem.amount;
				for(var j=0; j<array_length(neededItems); j++)  {
					var neededItem = neededItems[j];
					//Remove item from each stack
					amountToRemove = removeFromItem(neededItem, amountToRemove);
					//If there isn't any more of this required item to remove, then continue on to the next item.
					if(amountToRemove == 0)
						break;
				}
			}
			return duplicateItem(item);
		}
		else
			return craftPossible;
	}
	
}

function getHoverTextCrafting(reqItems, item) {
	var hoverText = "";
	hoverText += item.name + "\n";
	for(var i=0; i<array_length(reqItems); i++) {
		var itemOrScript = reqItems[i];
		if(isItem(itemOrScript)) 
			hoverText += itemOrScript.name + " " + string(itemOrScript.amount) + "x\n";
		else
			hoverText += script_get_name(itemOrScript) + "\n";
	}
	return hoverText;
}

#region all items
#region wood

function WoodHatchet(amount = 1) : Axe(spr_woodHatchet,amount,room_speed*0.4,5,2,"Wood Hatchet", "Hatchet that can cut down trees\nDamage: 2", itemAnimations.SWORD) constructor {
	cooldown = room_speed*0.4;
	static leftPress = function(targX, targY) {
		with(other) {
			handProgress = 1;
			attackState = attackStates.MELEE;
			animType = itemAnimations.SWORD;
			var dir = point_direction(x, y, targX, targY);
			//Calculate the direction of the punch hitbox
			var xx = x + lengthdir_x(TILEW/2, dir);
			var yy = y + lengthdir_y(TILEW/2, dir);
			//Create dmg hitbox (hitboxes are more resource efficient compared to individial enemy collision checks)
			var inst = damageHitbox(
				xx,yy,
				24,24,
				targX,targY,
				2,
				10,3,
				object_is_ancestor(object_index, obj_enemy),
				true, false,
				xx-x,yy-y
			);
	
			if(!variable_instance_exists(inst, "resourceCollect"))
				variable_instance_set(inst, "resourceCollect", Axe);
		}
		return cooldown;
	}
}
	
function Wood(amount = 1) : Item(spr_wood,amount,0,"Wood","Resource") constructor {}	

function WoodStick(amount = 1) : Item(spr_woodStick,amount,0,"Wood Stick","A stick that serves as\n a handle for all sorts\n of weapons.") constructor {}

function Handle(amount = 1) : Item(spr_woodHandle,amount,0,"Handle","A handle used for swords") constructor {}

function WoodSword(amount = 1) : Sword(spr_woodSword,amount,room_speed*0.2,10,3,"Wood Sword", "Perfect sword for training...\n or combat if you are brave enough.") constructor {}

function Bow(amount = 1) : Item(spr_bow,amount,10,"Bow","A bow that shoots arrows", itemAnimations.KNIFE_STAB) constructor{
	cooldown = room_speed*0.7;
	maxCharge = room_speed;
	projSpd = 10;
	
	static leftDown = function() {
		if(!variable_instance_exists(other.id, "charge"))
			other.charge = 0;
		if(!variable_instance_exists(other.id, "charged"))
			other.charged = 0;
			
		other.charge++;
		if(other.charge > maxCharge) {
			other.charged = true;
		}
	}
	
	static leftRelease = function(targX, targY) {
		if(other.charged) {
			other.charge = 0;
			other.charged = false;
			instance_create_depth(other.x,other.y,0,obj_arrow, {
				damage : damage,
				speed : projSpd,
				fromEnemy : object_is_ancestor(other.object_index, obj_enemy),
				direction : point_direction(other.x,other.y, targX,targY),
			})
			return cooldown;
		}
		other.charge = 0;
		other.charged = false;
	}
}

#endregion wood

#region iron

function Iron(amount = 1) : Item(spr_iron,amount,0,"Iron","Resource") constructor {};

function IronSword(amount = 1) : Sword(spr_ironSword,amount,room_speed*0.2,TILEW*0.1,5,"Iron sword","Forged by an unknown blacksmith.") constructor {}

function IronHatchet(amount = 1) : 
	Axe(spr_ironHatchet,amount,room_speed*0.4,5,2,"Iron Hatchet", "Forged by an unknown blacksmith.\nDamage: 2", itemAnimations.SWORD) 
	constructor 
{
	cooldown = room_speed*0.4;
	static leftPress = function(targX, targY) {
		with(other) {
			handProgress = 1;
			attackState = attackStates.MELEE;
			animType = itemAnimations.SWORD;
			var dir = point_direction(x, y, targX, targY);
			//Calculate the direction of the punch hitbox
			var xx = x + lengthdir_x(TILEW/2, dir);
			var yy = y + lengthdir_y(TILEW/2, dir);
			//Create dmg hitbox (hitboxes are more resource efficient compared to individial enemy collision checks)
			var inst = damageHitbox(
				xx,yy,
				24,24,
				targX,targY,
				damage,
				10,3,
				object_is_ancestor(object_index, obj_enemy),
				true, false,
				xx-x,yy-y
			);
	
			if(!variable_instance_exists(inst, "resourceCollect"))
				variable_instance_set(inst, "resourceCollect", Axe);
		}
		return cooldown;
	}
}

#endregion iron

function Gold(amount = 1) : Item(spr_gold,amount,3,"Gold","") constructor {} 

function BasicWand(amount = 1) : Item(spr_basicWand,amount,5,"Basic Wand", "A twig that never rots.") constructor {}

function String(amount = 1) : Item(spr_string,amount,0,"String","Made of simple fibres") constructor {};

function Berry(amount = 1) : Food(spr_berry,amount,0.5,0,"Berry","Freshly picked from bushes\nHeal:0.5") constructor {};

function Bandage(amount = 1) : Food(spr_bandage,amount,2,0,"Bandage","Heals you 1 health when consumed") constructor {};

#endregion all items

//Called by obj_shopItem only.
function buyItem() {
	newTextBox(
		"Description: " + item.desc +
		"\nPrice: " + string(price) +
		"\nPurchase" + item.name + "?",
		
		["1:Buy", "0:Don't buy"]
	);
}