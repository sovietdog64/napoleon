function InvSearch(invArray, itemSprite, amount = 1) {
	for(var i=0; i<array_length(invArray); i++)
		if(isItem(invArray[i]) && invArray[i].itemSpr == itemSprite)
				if(invArray[i].amount >= amount)
					return i;
			
	return -1;
}

function InvGet(invArray, itemSprite, amount = 1) {
	var pos = InvSearch(invArray, itemSprite, amount);
	if(pos != -1)
		return invArray[pos];
	return undefined;
}

function InvSearchPlayer( itemSprite, amount = 1) {
	var pos = InvSearch(global.invItems, itemSprite, amount);
	if(pos == -1)
		pos = InvSearch(global.hotbarItems, itemSprite, amount);
	return pos;
}

function InvRemove(invArray, itemSprite, amount = undefined) {
	var item = InvSearch(invArray, itemSprite);
	if(isItem(item)) {
		if(amount != undefined) {
			item.amount -= amount;
			return true;
		}
		else {
			item.amount = 0;
			return true;
		}
	}
	return false;
}

function InvAdd(invArray, item) {
	if(!isItem(item))
		return false;
	for(var i=0; i<array_length(invArray); i++) {
		var invItem = invArray[i];
		if(isItem(invItem) && invItem.itemSpr == item.itemSpr) {
			invItem.amount += item.amount;
			return true;
		}
		else if(invItem == -1) {
			invArray[i] = item;
			return true;
		}
	}
	return false;
}
	
function duplicateItem(item) {
	if(!isItem(item))
		return item;
	return copyStruct(item);
}

function removeEmptyItems(invArray) {
	for(var i=0; i<array_length(invArray); i++) {
		if(!isItem(invArray[i]))
			continue;
		if(invArray[i].amount <= 0)
			invArray[i] = -1;
	}
}

//invs are the inv arrays
//a slot is an index in the array
function InvSwap(invFrom, slotFrom, invTo, slotTo) {
	var itemFrom = duplicateItem(invFrom[slotFrom]);
	invFrom[slotFrom] = duplicateItem(invTo[slotTo]);
	invTo[slotTo] = itemFrom;
}
	
function pointInSprite(px, py, sprite, sprX, sprY) {
	var w = sprite_get_width(sprite);
	var h = sprite_get_height(sprite);
	var xOff = sprite_get_xoffset(sprite);
	var yOff = sprite_get_yoffset(sprite);
	//Make function check from top left of sprite
	sprX -= xOff;
	sprY -= yOff;
	return point_in_rectangle(px, py, sprX, sprY, sprX+w, sprY+w)
}

function openPlayerInv() {
	instance_create_depth(0,0,0,obj_playerInvScreen);
}

function closeAllInvs() {instance_destroy(obj_inventory)};

function closeInv(inv) {instance_destroy(inv)};

function CraftingRecipie(_item, _itemsRequired) {
	item = _item;
	itemsRequired = _itemsRequired;
	
	//Checks if can craft an item
	//If cannot, it will return an array of the missing items
	static canCraft = function() {
		var craftable = true;
		var missingItems = [];
		//the var "craftable" will remain true until a missing item is found
		for(var i=0; i<array_length(itemsRequired); i++) {
			var reqItem = itemsRequired[i];
			//If missing item, set craftable to false & add the required item to list of missing items
			//else, continue in the loop
			if(InvSearchPlayer(reqItem.itemSpr, reqItem.amount) == -1) {
				craftable = false;
				array_push(missingItems, reqItem);
			}
		}
		
		if(craftable)
			return true;
		else
			return missingItems;
	}
	
	static craftItem = function() {
		var craftedItem = canCraft();
		if(craftedItem) {
			return item;
		}
		else
			return -1;
	}
	
}